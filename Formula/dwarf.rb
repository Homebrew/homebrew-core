class Dwarf < Formula
  desc "Object file manipulation tool"
  homepage "https://github.com/elboza/dwarf-ng/"
  url "https://github.com/elboza/dwarf-ng/archive/dwarf-0.4.0.tar.gz"
  sha256 "a64656f53ded5166041ae25cc4b1ad9ab5046a5c4d4c05b727447e73c0d83da0"
  revision 1

  bottle do
    cellar :any
    sha256 "c10f3ccbb2dc59b7c76c9dd46a71f1e41d7c7faa8fab5f4326599b3a5467c770" => :mojave
    sha256 "92db022169f222a0ce002e6c20e6256cc5636f61c1e6fa1c44b56481c5a2422d" => :high_sierra
    sha256 "dbc5a7043b5888284ddab1d97b57406fc6c24d71c205a54482e3ef0e442e20fd" => :sierra
  end

  depends_on "flex"
  depends_on "readline"

  def install
    %w[src/libdwarf.c doc/dwarf.man doc/xdwarf.man.html].each do |f|
      inreplace f, "/etc/dwarfrc", etc/"dwarfrc"
    end

    system "make"
    system "make", "install", "BINDIR=#{bin}", "MANDIR=#{man1}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>

      int main(int argc, char *argv[]) {
        printf("hello world\\n");
      }
    EOS
    system ENV.cc, "test.c", "-o", "test"
    output = shell_output("#{bin}/dwarf -c 'pp $mac' test")
    assert_equal "magic: 0xfeedfacf (-17958193)", output.lines[0].chomp
  end
end
