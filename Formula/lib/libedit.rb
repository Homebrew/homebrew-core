class Libedit < Formula
  desc "BSD-style licensed readline alternative"
  homepage "https://thrysoee.dk/editline/"
  url "https://thrysoee.dk/editline/libedit-20260512-3.1.tar.gz"
  version "20260512-3.1"
  sha256 "432d5e7ea8b0116dd39f2eca7bc11d0eed77faa6b77ea526ace89907c23ea4a0"
  license "BSD-3-Clause"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?libedit[._-]v?(\d{4,}-\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5c492117cec71184a93a09376a1aee72909f40c335a81646c0f74f38803544e1"
    sha256 cellar: :any,                 arm64_sequoia: "af552c0f546111e4333311902b33af82568abc75de0b3c93ee40e6af184c23b8"
    sha256 cellar: :any,                 arm64_sonoma:  "5d39eeec2e2c432bf0aa2f6e7e16f8c5a6cfdb5309e7b81b4206d8bfcf310508"
    sha256 cellar: :any,                 sonoma:        "c431de92bb4497f1e474d0141530b1a6867da633976434a6b38b63f552cd42ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ee15b0b1cc6e265dd7a39326cfdeb7e2c72ad5e8943f40f328ddfcb72690e81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d9a605075987c2f832b9caa24b1a5b56dee88ae662cb6a4efee375fce1d8dcf"
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
