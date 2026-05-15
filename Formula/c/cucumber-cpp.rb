class CucumberCpp < Formula
  desc "Support for writing Cucumber step definitions in C++"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-cpp.git",
      tag:      "v0.8.0",
      revision: "38bd34a3caaeb3fa6ab80d09b323e1a9d6fe24b7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "35223aa4c6b55a58d5791ee51e2ae47359e11a8c4cf4512227e13150d443a4e3"
    sha256 cellar: :any,                 arm64_sequoia: "22354d052564f4bf8e49d62f5b99f1789c39fadba6e1ae42aaf7d44ad4fd7a20"
    sha256 cellar: :any,                 arm64_sonoma:  "c99200855796c764cf8fb723fe2f70ba8a4c53dfe5b880ee3c2fe2ac85dbfc68"
    sha256 cellar: :any,                 sonoma:        "3b9169520a6eb955a10b97cdcd5de61709a49df4b047a60fb52db09e03a0b83b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18c389442081099600284c429bcb1693cdbde8af1c2705750d4d358918e4cbfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f94c8fe6c5d816f8b8a8e7cb6885d032e8a27431827ad6fd96aea155d37bc66c"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "ruby" => :test
  depends_on "asio"
  depends_on "tclap"

  def install
    args = %w[
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
