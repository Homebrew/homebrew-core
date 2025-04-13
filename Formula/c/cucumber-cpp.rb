class CucumberCpp < Formula
  desc "Support for writing Cucumber step definitions in C++"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-cpp.git",
      tag:      "v0.7.0",
      revision: "ceb025fb720f59b3c8d98ab0de02925e7eab225c"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebd1f734db83ae5e745b5a870609430170ac0a4db66d0a982054f17f9c11df23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9d57c131eb3c28dacc0dc5191e0db536837ff6c0c3e1c00b18bbde206cbccea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83b0a4ebd24369723ca462379eec507069b69745b0162aaf8e52fbd191912f8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "552c285dcbfdfeeeee4918504197d55608bcdd7a6f545c7b128b9a3ec4de66bd"
    sha256 cellar: :any_skip_relocation, ventura:       "f174b4c1f7188ec9cbfa63d42a7858b5b6055d46b4e8ef9e01603aa6a8f504a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b10926942356d39fb0ec167e488e3d170a265824e3afee947643ab71b8be4bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fdfd1f3eb9ae326c0490d8f17f4b68adebd5c48382bae283de89b9bb835b994"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "ruby" => :test
  depends_on "asio"
  depends_on "tclap"

  def install
    # TODO: Remove these on next release as they are the defaults
    args = %w[
      -DCUKE_ENABLE_BOOST_TEST=OFF
      -DCUKE_ENABLE_GTEST=OFF
      -DCUKE_ENABLE_QT=OFF
      -DCUKE_TESTS_UNIT=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    doc.install "examples"
  end

  test do
    ENV.prepend_path "PATH", Formula["ruby"].opt_bin
    ENV["GEM_HOME"] = testpath
    ENV["BUNDLE_PATH"] = testpath

    system "gem", "install", "cucumber:9.2.1", "cucumber-wire:7.0.0", "--no-document"

    (testpath/"features/test.feature").write <<~CUCUMBER
      Feature: Test
        Scenario: Just for test
          Given A given statement
          When A when statement
          Then A then statement
    CUCUMBER
    (testpath/"features/step_definitions/cucumber.wire").write <<~EOS
      host: localhost
      port: 3902
    EOS
    (testpath/"features/support/wire.rb").write <<~RUBY
      require 'cucumber/wire'
    RUBY
    (testpath/"test.cpp").write <<~CPP
      #include <cucumber-cpp/generic.hpp>
      GIVEN("^A given statement$") {
      }
      WHEN("^A when statement$") {
      }
      THEN("^A then statement$") {
      }
    CPP

    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-lcucumber-cpp", "-pthread"

    begin
      pid = spawn "./test"
      sleep 1
      expected = <<~EOS
        Feature: Test

          Scenario: Just for test
            Given A given statement
            When A when statement
            Then A then statement

        1 scenario (1 passed)
        3 steps (3 passed)
      EOS
      assert_match expected, shell_output("#{testpath}/bin/cucumber --quiet")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
