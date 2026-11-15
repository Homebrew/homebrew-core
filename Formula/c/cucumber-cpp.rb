class CucumberCpp < Formula
  desc "Support for writing Cucumber step definitions in C++"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-cpp.git",
      tag:      "v0.9.0",
      revision: "3a906521e53846b4c5d59b994e4b60655097d5ea"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "87fbd1fde771e87cc1cf6912f0ce365b2b543255c6bc75da2f1c2fadcb11a7b6"
    sha256 cellar: :any, arm64_tahoe:       "9378982184549953aca702549098a4ae2d5a222d04f1b1a66127e2debfecd685"
    sha256 cellar: :any, arm64_sequoia:     "9faf7c36dd7918e0eea7b3f7e6bbd1945906930d87e0bb65b345b5a8c0519520"
    sha256 cellar: :any, arm64_linux:       "8414c70a32e4aa9a84cae73dac6bc80a24f3bde1187e2c278ba3acfc2a03651c"
    sha256 cellar: :any, x86_64_linux:      "4f2f59e8cfae15023fde76bd1582e7888687a08f8af4cb10a6f55124c7699689"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "ruby" => :test
  depends_on "asio"
  depends_on "tclap"

  allow_network_access! :test

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
    ENV.prepend_path "PATH", formula_opt_bin("ruby")
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
