class Dwarf < Formula
  desc "Object file manipulation tool"
  homepage "https://code.google.com/p/dwarf-ng/"
  url "https://github.com/elboza/dwarf-ng/archive/dwarf-0.3.1.tar.gz"
  sha256 "921667018e0edb057d695cdb6b7ed3bd8922a4050506252c21fffe4f7e77be2e"
  revision 1

  bottle do
    cellar :any
    sha256 "1d89b27dfdfdc133e6987891427957b1cced0aa2a8a27fa51c3b91a0cfe5e5a4" => :sierra
    sha256 "a75413f26540b97f2ec50506923483718a48af536dc6aeda91ba7512ed84a55a" => :el_capitan
    sha256 "2edfda127ec9276342162f4ba44e44a18c623c981992a310d1a2ae6267a7b10a" => :yosemite
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "readline"

  # Build fails with clang due to -Wreturn-type errors
  # Reported 2nd May 2016: https://github.com/elboza/dwarf-ng/issues/2
  # Opened PR with a fix 2nd May 2016: https://github.com/elboza/dwarf-ng/pull/4
  patch do
    url "https://github.com/elboza/dwarf-ng/pull/4.patch"
    sha256 "081be99b41c9af0940cae6a4398baaab8dec61df80358fa54defb9e20360f416"
  end

  def install
    %w[src/libdwarf/libdwarf.c doc/dwarf.man].each do |f|
      inreplace f, "/etc/dwarfrc", etc/"dwarfrc"
    end

    # Fix "error: unknown type name 'intmax_t'" and the same for 'uintmax_t'
    # Reported 22nd Aug 2015: https://github.com/elboza/dwarf-ng/issues/1
    inreplace "src/libdwarf/stdint.h",
      "typedef unsigned long long   uint64_t;",
      "typedef unsigned long long   uint64_t;\ntypedef long intmax_t;\ntypedef unsigned long uintmax_t;"

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"

    # Fix parallelized build failure: "no rule to make target `y.tab.h'"
    # Reported 2nd May 2016: https://github.com/elboza/dwarf-ng/issues/3
    %w[src/cmdline src/libdwarf].each { |d| system "make", "-C", d, "y.tab.c" }

    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>

      int main(int argc, char *argv[]) {
        printf("hello world\\n");
      }
    EOS
    system ENV.cc, "test.c", "-o", "test"
    assert_equal "magic: 0xfeedfacf (-17958193)", pipe_output("#{bin}/dwarf -c 'print $mac' test").lines.first.chomp
  end
end
