class Gflags < Formula
  desc "Library for processing command-line flags"
  homepage "https://gflags.github.io/gflags/"
  url "https://github.com/gflags/gflags/archive/v2.2.2.tar.gz"
  sha256 "34af2f15cf7367513b352bdcd2493ab14ce43692d2dcd9dfc499492966c64dcf"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "6e795ef1c92a6c9a29df890b9113e48e30576ad72e1fd86bf0874cc9a8c1f042"
    sha256 cellar: :any,                 arm64_monterey: "b7b14b5ab926ce5519ac34e1998f50fcd086eea1f0cb964fdae920e1c559162a"
    sha256 cellar: :any,                 arm64_big_sur:  "3c47ffe18412eab890f339191cfe1b9142d7eb9d499d68ac4ac55db2707e6f3b"
    sha256 cellar: :any,                 ventura:        "0b45c10f7b0dc5db1b939b80fc4839aaf04e4e4c51ea7341aff3aeb25b47d7aa"
    sha256 cellar: :any,                 monterey:       "131b300ff91b74fc06ef08208a7474c6f21d46ea785e0d76f236d5167d4ecbdf"
    sha256 cellar: :any,                 big_sur:        "013d34b7e3e9ef0b1ebae5c0bad9661cf1462a4fddec2e31c27dbacb5e8697b9"
    sha256 cellar: :any,                 catalina:       "ebc7b6a9b5c14419f01a763f8b5d178525231d0fb4f5a4768673745a893f3b0b"
    sha256 cellar: :any,                 mojave:         "e3176e449321b1e2070a9fabc796e6820f2f0f1f4db1c3916f58e6cdd52e510e"
    sha256 cellar: :any,                 high_sierra:    "4beffa84f47bdfd9a1a90d9e591d9af4616db464d63046018ef0c58936d58366"
    sha256 cellar: :any,                 sierra:         "6f06466ca55f2174daecbc935e0bca1f2aed9bfb94a92f21d52fb4db1e07cd4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abf5d21a3d9ebed989bc047eec0c14b0b22a53ca0f1140149e158a89cd06a31f"
  end

  depends_on "cmake" => :build

  def install
    mkdir "buildroot" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include "gflags/gflags.h"

      DEFINE_bool(verbose, false, "Display program name before message");
      DEFINE_string(message, "Hello world!", "Message to print");

      static bool IsNonEmptyMessage(const char *flagname, const std::string &value)
      {
        return value[0] != '\0';
      }
      DEFINE_validator(message, &IsNonEmptyMessage);

      int main(int argc, char *argv[])
      {
        gflags::SetUsageMessage("some usage message");
        gflags::SetVersionString("1.0.0");
        gflags::ParseCommandLineFlags(&argc, &argv, true);
        if (FLAGS_verbose) std::cout << gflags::ProgramInvocationShortName() << ": ";
        std::cout << FLAGS_message;
        gflags::ShutDownCommandLineFlags();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lgflags", "-o", "test"
    assert_match "Hello world!", shell_output("./test")
    assert_match "Foo bar!", shell_output("./test --message='Foo bar!'")
  end
end
