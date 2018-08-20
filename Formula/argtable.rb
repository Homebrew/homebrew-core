class Argtable < Formula
  desc "ANSI C library for parsing GNU-style command-line options"
  homepage "https://argtable.sourceforge.io"
  url "https://downloads.sourceforge.net/project/argtable/argtable/argtable-2.13/argtable2-13.tar.gz"
  version "2.13"
  sha256 "8f77e8a7ced5301af6e22f47302fdbc3b1ff41f2b83c43c77ae5ca041771ddbf"

  bottle do
    cellar :any
    sha256 "61ec2ac4b9e65f7965931dfd983848fae06130686c4f800eb9341f96a6f6d398" => :mojave
    sha256 "e68b3df66d638a024c3b57b069bcdebfbdabb230a9c851de886321c2b3df7099" => :high_sierra
    sha256 "9485d1e045ed40c0145eb867f9d24425ccedd53b4f0cb0ec949139b0c99507c7" => :sierra
    sha256 "0a720e738557215bf1b58fa642ec2fc51971da38e98b987862fcd05cc54756f7" => :el_capitan
    sha256 "9e9d1451712580f090f0078ec7774a0daeb1057be3b1762e3d8465264d969432" => :yosemite
    sha256 "7081198c76023e34380d35682b7a4274a9faf98d3e3e3fa2a9fa801e0a320a8c" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "argtable2.h"
      #include <assert.h>
      #include <stdio.h>

      int main (int argc, char **argv) {
        struct arg_lit *all = arg_lit0 ("a", "all", "show all");
        struct arg_end *end = arg_end(20);
        void *argtable[] = {all, end};

        assert (arg_nullcheck(argtable) == 0);
        if (arg_parse(argc, argv, argtable) == 0) {
          if (all->count) puts ("Received option");
        } else {
          puts ("Invalid option");
        }
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-largtable2",
                   "-o", "test"
    assert_match "Received option", shell_output("./test -a")
    assert_match "Received option", shell_output("./test --all")
    assert_match "Invalid option", shell_output("./test -t")
  end
end
