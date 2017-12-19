class CucumberCpp < Formula
  desc "Support for writing Cucumber step definitions in C++"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-cpp/archive/v0.4.tar.gz"
  sha256 "57391dfade3639e5c219463cecae2ee066c620aa29fbb89e834a7067f9b8e0c8"
  revision 4

  bottle do
    cellar :any_skip_relocation
    sha256 "75027c787492808d86f1c0855f4f46e8c4fe6fe50bde934877b894ccd8192a73" => :high_sierra
    sha256 "f6bb37716c95ccf157e934037fe3d8a8bcb5757d85ebbdfc7c3e2b057f2bac43" => :sierra
    sha256 "d06585a0d493796e50c66ff38d794391cab7d66c6eb93c42cc6e2467f321767e" => :el_capitan
    sha256 "bd1a3eff22dffabfaf55e17c7b32e9116068f253a051eeca52840eb4d747d555" => :yosemite
  end

  depends_on "cmake" => :build

  # Upstream issue from 19 Dec 2017 "Build fails with Boost 1.66.0"
  # See https://github.com/cucumber/cucumber-cpp/issues/178
  depends_on "boost@1.60"

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
           "-lcucumber-cpp", "-I#{Formula["boost@1.60"].opt_include}",
           "-L#{Formula["boost@1.60"].opt_lib}", "-lboost_regex", "-lboost_system",
           "-lboost_program_options", "-lboost_filesystem"
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
