class CucumberCpp < Formula
  desc "Support for writing Cucumber step definitions in C++"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-cpp.git",
      tag:      "v0.7.0",
      revision: "ceb025fb720f59b3c8d98ab0de02925e7eab225c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e52705eba218bc405d689160e6e28308ff0f2f33bcddf6ec85898c0cfcab1e1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c03f2daaf1def843478d7d144500cef481190e79eb145fcc25844352223412b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8ae30b6185669938d6bf21a83a84acb8d56bc59194a4b1b28feb6b986d77da9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b629690ec414931c52c1796dedc8e8bf5a4dfcf70c73ed7dcc4f091894ec5f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "082e66cef0aeabaaf1aeb24b4d47396613b37ed28b3739a99452da70a819ca13"
    sha256 cellar: :any_skip_relocation, ventura:        "fda51f7ecd0df9092e3734f44a3e0fe1ed88a8d9a084e25f2379c70c76ac7243"
    sha256 cellar: :any_skip_relocation, monterey:       "ad29a2f7f882a4376e053a851645aa251a95679a6099aaa8931c9c3a98160045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c9e95d394b01d3a55aee2d7b2add5de066e47843a7c98f58a9a30c58346fff0"
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

    system "gem", "install", "cucumber:9.1.1", "cucumber-wire:7.0.0", "--no-document"

    (testpath/"features/test.feature").write <<~EOS
      Feature: Test
        Scenario: Just for test
          Given A given statement
          When A when statement
          Then A then statement
    EOS
    (testpath/"features/step_definitions/cucumber.wire").write <<~EOS
      host: localhost
      port: 3902
    EOS
    (testpath/"features/support/wire.rb").write <<~EOS
      require 'cucumber/wire'
    EOS
    (testpath/"test.cpp").write <<~EOS
      #include <cucumber-cpp/generic.hpp>
      GIVEN("^A given statement$") {
      }
      WHEN("^A when statement$") {
      }
      THEN("^A then statement$") {
      }
    EOS

    cxx_args = %W[
      -std=c++17
      test.cpp
      -o
      test
      -I#{include}
      -L#{lib}
      -lcucumber-cpp
      -pthread
    ]
    system ENV.cxx, *cxx_args

    begin
      pid = fork { exec "./test" }
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
