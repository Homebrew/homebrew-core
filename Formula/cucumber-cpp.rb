class CucumberCpp < Formula
  desc "Support for writing Cucumber step definitions in C++"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-cpp/archive/v0.3.1.tar.gz"
  sha256 "442c3fc3020c709f5609e33b76e25c3c9fc9166911e74f590590f794f24f8a9b"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "9286f8466f9dfe9b12283f619b42684613635d02976d65f1413c30988428eef7" => :sierra
    sha256 "91368b3bf33064c048ba322f6bf50325a96a51954ccfed3547993df214f49589" => :el_capitan
    sha256 "ff6e6139ce7845ec9f6c3ef4379562d4e0976fda3e37c4ac3ccab6cb2a971979" => :yosemite
    sha256 "0584217a82ab5d88b71a628b69918eb4cb274d1f568f56a43dc2dc18b3f144bf" => :mavericks
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
      #include <cucumber-cpp/defs.hpp>
      GIVEN("^A given statement$") {
      }
      WHEN("^A when statement$") {
      }
      THEN("^A then statement$") {
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lcucumber-cpp", "-o", "test",
      "-lboost_regex", "-lboost_system", "-lboost_program_options"
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
