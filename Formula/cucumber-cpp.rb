class CucumberCpp < Formula
  desc "Support for writing Cucumber step definitions in C++"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-cpp/archive/v0.5.tar.gz"
  sha256 "9e1b5546187290b265e43f47f67d4ce7bf817ae86ee2bc5fb338115b533f8438"
  revision 4

  bottle do
    cellar :any_skip_relocation
    sha256 "d89be4fb4e823bc33463728ec21e9b87a917bb5280469d85b16d55adc9b9ea05" => :mojave
    sha256 "e7dfbf7237b801a4337608b708bef04e6271a27f4d1a3cb99273ce986657956d" => :high_sierra
    sha256 "4dd3ef1e73c533952f3ba8399bc5edeec223ff31478c80595ed9e9e9140fb2f8" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "ruby" => :test if MacOS.version <= :sierra
  depends_on "boost"

  def install
    args = std_cmake_args + %w[
      -DCUKE_DISABLE_GTEST=on
      -DCUKE_DISABLE_CPPSPEC=on
      -DCUKE_DISABLE_FUNCTIONAL=on
      -DCUKE_DISABLE_BOOST_TEST=on
    ]

    # Temporary fix for bad boost 1.70.0 / cmake interaction
    # https://github.com/Homebrew/homebrew-core/pull/38890
    args << "-DBoost_NO_BOOST_CMAKE=ON"

    system "cmake", ".", *args
    system "cmake", "--build", "."
    system "make", "install"
  end

  test do
    ENV["GEM_HOME"] = testpath
    ENV["BUNDLE_PATH"] = testpath
    if MacOS.version == :high_sierra
      ENV.delete("CPATH")
      ENV.delete("SDKROOT")
    end
    system "gem", "install", "cucumber", "-v", "3.0.0"

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
    (testpath/"test.cpp").write <<~EOS
      #include <cucumber-cpp/generic.hpp>
      GIVEN("^A given statement$") {
      }
      WHEN("^A when statement$") {
      }
      THEN("^A then statement$") {
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}",
           "-lcucumber-cpp", "-I#{Formula["boost"].opt_include}",
           "-L#{Formula["boost"].opt_lib}", "-lboost_regex", "-lboost_system",
           "-lboost_program_options", "-lboost_filesystem", "-lboost_chrono"
    begin
      pid = fork { exec "./test" }
      expected = <<~EOS
        Feature: Test

          Scenario: Just for test   # features\/test.feature:2
            Given A given statement # test.cpp:2
            When A when statement   # test.cpp:4
            Then A then statement   # test.cpp:6

        1 scenario \(1 passed\)
        3 steps \(3 passed\)
      EOS
      assert_match expected, shell_output(testpath/"bin/cucumber")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
