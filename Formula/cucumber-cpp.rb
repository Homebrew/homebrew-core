class CucumberCpp < Formula
  desc "Support for writing Cucumber step definitions in C++"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-cpp/archive/v0.4.tar.gz"
  sha256 "57391dfade3639e5c219463cecae2ee066c620aa29fbb89e834a7067f9b8e0c8"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d9ed526b8f6d66b29add16c09f07f2298f3ec26f62c3105caaa832ba57d89d9" => :sierra
    sha256 "5900c7c70fc4814f069ba98a1712c14131e90533410462e68775a6eea36501c5" => :el_capitan
    sha256 "a1ddac23ff567418aa17e2d829d93c2e702d3a9b8b0217079dc330bfd5f02c95" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    args = std_cmake_args
    args << "-DCUKE_DISABLE_GTEST=on"
    args << "-DCUKE_DISABLE_CPPSPEC=on"
    args << "-DCUKE_DISABLE_FUNCTIONAL=on"
    args << "-DCUKE_DISABLE_BOOST_TEST=on"
    system "cmake", ".", *args
    system "cmake", "--build", "."
    include.install "include/cucumber-cpp"
    lib.install Dir["src/*.a"]
  end

  test do
    ENV["GEM_HOME"] = testpath
    ENV["BUNDLE_PATH"] = testpath
    system "gem", "install", "cucumber"

    (testpath/"features/test.feature").write <<-EOS.undent
      Feature: Test
        Scenario: Just for test
          Given A given statement
          When A when statement
          Then A then statement
    EOS
    (testpath/"features/step_definitions/cucumber.wire").write <<-EOS.undent
      host: localhost
      port: 3902
    EOS
    (testpath/"test.cpp").write <<-EOS.undent
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
           "-lboost_program_options", "-lboost_filesystem"
    begin
      pid = fork { exec "./test" }
      expected = <<-EOS.undent
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
