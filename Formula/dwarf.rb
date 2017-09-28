class Dwarf < Formula
  desc "Object file manipulation tool"
  homepage "https://github.com/elboza/dwarf-ng/"
  url "https://github.com/elboza/dwarf-ng/archive/dwarf-0.4.0.tar.gz"
  sha256 "a64656f53ded5166041ae25cc4b1ad9ab5046a5c4d4c05b727447e73c0d83da0"

  bottle do
    sha256 "ef1d01f93b35c4661d08b9a8a710cd99092a533735c646db2e205c8f2db93b95" => :high_sierra
    sha256 "84c3d641587619c55073a819edf62b23a6437aeed72075e257272df685e226aa" => :sierra
    sha256 "053fba2171b46fe1d9fd22f52ca5eee61e462682e2b9340c671505e5351fd5d6" => :el_capitan
    sha256 "1a798403cb54f055465e16fe67e7db63dd693ee993d0a871c32c6f143621d7f3" => :yosemite
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
    (testpath/"test.c").write <<-EOS.undent
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
