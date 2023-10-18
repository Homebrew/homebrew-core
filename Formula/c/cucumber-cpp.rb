class CucumberCpp < Formula
  desc "Support for writing Cucumber step definitions in C++"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-cpp/archive/v0.5.tar.gz"
  sha256 "9e1b5546187290b265e43f47f67d4ce7bf817ae86ee2bc5fb338115b533f8438"
  license "MIT"
  revision 9

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e87212f6030783f55ba38528ffda7715ae31a02c154c50d10430ea5123e4abca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d540f6ce4b8341c81108b6982fb397ca81ddcdd198f42f2272cde4c663a2c2cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3555ced3da78df86ea2167719051e71050ae478872f5440d4d1f23204f3efb7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b26e8188eba3e33e66af2fee3f89fcfd491575d1a7279dd122dcbf3c97947b9b"
    sha256 cellar: :any_skip_relocation, sonoma:         "f5d1c61654144668ef342b8814419bfcd3070644f9d9ca0009b971f09ce555a4"
    sha256 cellar: :any_skip_relocation, ventura:        "b904ae5c64aad86e153669a30bbda4f2d47047599e02a7487c6f68acb4b1606c"
    sha256 cellar: :any_skip_relocation, monterey:       "84d4a28b5728185faa0c082cc158481fa7636a69010958ea34ffbeae85210301"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fb0eea94924ccd3bdab9cb11e9647d11c650f0c8c769517e74d3bdb169fb44b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff0facd9e406ff16390aafc6d412f0a88ce26507b7829aca0aee8e77b7ec95e8"
  end

  depends_on "cmake" => :build
  depends_on "ruby" => :test
  depends_on "boost"

  def install
    args = std_cmake_args + %w[
      -DCUKE_DISABLE_GTEST=on
      -DCUKE_DISABLE_CPPSPEC=on
      -DCUKE_DISABLE_FUNCTIONAL=on
      -DCUKE_DISABLE_BOOST_TEST=on
      -DCMAKE_CXX_STANDARD=11
    ]

    system "cmake", ".", *args
    system "cmake", "--build", "."
    system "make", "install"
  end

  test do
    boost = Formula["boost"]
    ENV.prepend_path "PATH", Formula["ruby"].opt_bin
    ENV["GEM_HOME"] = testpath
    ENV["BUNDLE_PATH"] = testpath

    system "gem", "install", "cucumber", "-v", "5.2.0"

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
           "-lcucumber-cpp", "-I#{boost.opt_include}",
           "-L#{boost.opt_lib}", "-lboost_regex", "-lboost_system",
           "-lboost_program_options", "-lboost_filesystem", "-lboost_chrono",
           "-pthread"
    begin
      pid = fork { exec "./test" }
      sleep 5
      expected = <<~EOS
        Feature: Test

          Scenario: Just for test   # features/test.feature:2
            Given A given statement # test.cpp:2
            When A when statement   # test.cpp:4
            Then A then statement   # test.cpp:6

        1 scenario (1 passed)
        3 steps (3 passed)
      EOS
      assert_match expected, shell_output("#{testpath}/bin/cucumber --publish-quiet")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
