class Dwarf < Formula
  desc "Object file manipulation tool"
  homepage "https://github.com/elboza/dwarf-ng/"
  url "https://github.com/elboza/dwarf-ng/archive/dwarf-0.4.0.tar.gz"
  sha256 "a64656f53ded5166041ae25cc4b1ad9ab5046a5c4d4c05b727447e73c0d83da0"

  bottle do
    sha256 "13e3227b35f3efb0ccd3d91c8ce2786b10fc24a2060a478fa36581197b237c23" => :mojave
    sha256 "47af5ca1f6349c0d8c49f1ef72cbed7fbaa6e91c263c8a284afd841e8ced56f9" => :high_sierra
    sha256 "69a1b11620f73e519cf6abade5a23e478a4c7c44cd4fbc9996b05c464c53e8d7" => :sierra
    sha256 "042c140300ff583047ec5f51e3877b4ecf22a3c25a6108c11ae067b9e525d05b" => :el_capitan
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
