class CucumberCpp < Formula
  desc "Support for writing Cucumber step definitions in C++"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-cpp/archive/v0.5.tar.gz"
  sha256 "9e1b5546187290b265e43f47f67d4ce7bf817ae86ee2bc5fb338115b533f8438"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "f51698030d9e59f888059a33fbf05aab2a14efa479cdc6167a7be9eed4963017" => :mojave
    sha256 "f4daf096bb414f9af8a3109bd699f97ae3ecf4e177d1f8f3bce01f3e5b8f4d26" => :high_sierra
    sha256 "b1049586b1ab62851e67629481bef7cdc596073fcb13124d127de402c029bdc7" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "ruby" => :test if MacOS.version <= :sierra
  depends_on "boost"

  def install
    args = std_cmake_args
    args << "-DCUKE_DISABLE_GTEST=on"
    args << "-DCUKE_DISABLE_CPPSPEC=on"
    args << "-DCUKE_DISABLE_FUNCTIONAL=on"
    args << "-DCUKE_DISABLE_BOOST_TEST=on"
    system "cmake", ".", *args
    system "cmake", "--build", "."
    system "make", "install"
  end

  test do
    ENV["GEM_HOME"] = testpath
    ENV["BUNDLE_PATH"] = testpath
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
