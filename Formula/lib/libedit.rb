class Libedit < Formula
  desc "BSD-style licensed readline alternative"
  homepage "https://thrysoee.dk/editline/"
  url "https://thrysoee.dk/editline/libedit-20251016-3.1.tar.gz"
  version "20251016-3.1"
  sha256 "21362b00653bbfc1c71f71a7578da66b5b5203559d43134d2dd7719e313ce041"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?libedit[._-]v?(\d{4,}-\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2957d416dfdc8c58a1dd666669d3c7d1330ba15ededc2438a4de3059ca8ec20b"
    sha256 cellar: :any,                 arm64_sequoia: "510068e4f21502b89b2c659b098f0f1a3adfa6e30e7cd77ec5389e78038026d9"
    sha256 cellar: :any,                 arm64_sonoma:  "ff578f10a3f9bd4c183f97578b0e92893d27a1fdcdd3093ddb7bff44d4e61416"
    sha256 cellar: :any,                 sonoma:        "a875f674adab029105a001dda7a43dbe44544887d73caad16a48cf7c51cacc4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e61d1403b27ad966a5aafaafafd2db88aace8c717d57aa561df5f7b6d1f1fc69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0e22aa9e7d09e78d35b2a97e87747271a8651f7eabe4d0e424756939718dfe2"
  end

  keg_only :provided_by_macos

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"

    # Create readline compatibility symlinks for use by license incompatible
    # software. We put these in libexec to avoid conflict with readline.
    # Similar to https://packages.debian.org/sid/libeditreadline-dev
    %w[history readline].each do |libname|
      (libexec/"include/readline").install_symlink include/"editline/readline.h" => "#{libname}.h"
      (libexec/"lib").install_symlink lib/shared_library("libedit") => shared_library("lib#{libname}")
      (libexec/"lib").install_symlink lib/"libedit.a" => "lib#{libname}.a"
    end
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <histedit.h>
      int main(int argc, char *argv[]) {
        EditLine *el = el_init(argv[0], stdin, stdout, stderr);
        return (el == NULL);
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-ledit", "-I#{include}"
    system "./test"
  end
end
