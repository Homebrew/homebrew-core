class CucumberCpp < Formula
  desc "Support for writing Cucumber step definitions in C++"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-cpp.git",
      tag:      "v0.7.0",
      revision: "ceb025fb720f59b3c8d98ab0de02925e7eab225c"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "a84c27a7c5c122364e12ee74e3140a6ccd22656fc6df6da1cf8dc29b3161cf3b"
    sha256 cellar: :any,                 arm64_sequoia: "35387bbcd3b131388528b44ac54f5d695d1fbc9c927d3b172d4793cba0c0ebb0"
    sha256 cellar: :any,                 arm64_sonoma:  "ff5c68f821cd56afe208298382d865e998f272cf64e8c9810a6154d570317176"
    sha256 cellar: :any,                 sonoma:        "9bf81577eead937163e41fcfa5c32bc9d913bca9364a3d5da546cef5a7fd3252"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29733451777a0846cf111ee7f5c165009c1a7ae22543252252282006a997b046"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4aced1fbb5e0c5eefff25bd4a29efdd7a719e1d14e68f915e89d1c04eef0659e"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "ruby" => :test
  depends_on "asio"
  depends_on "tclap"

  # Backport support for Asio 1.33+
  patch do
    url "https://github.com/cucumber/cucumber-cpp/commit/da6345bd1d0b0ac4cf4bc71866c98d55c72522a8.patch?full_index=1"
    sha256 "1ad7f6513ee2d41c5625933b05249704c14484a7029acd330c5f665a11e6a66f"
  end

  def install
    # TODO: Remove Cuke args on next release as they are the defaults
    args = %w[
      -DCUKE_ENABLE_BOOST_TEST=OFF
      -DCUKE_ENABLE_GTEST=OFF
      -DCUKE_ENABLE_QT=OFF
      -DCUKE_TESTS_UNIT=OFF
      -DBUILD_SHARED_LIBS=ON
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
