class Dwarf < Formula
  desc "Object file manipulation tool"
  homepage "https://github.com/elboza/dwarf-ng/"
  url "https://github.com/elboza/dwarf-ng/archive/dwarf-0.3.2.tar.gz"
  sha256 "dc3db5273c02f0b05beedada0a3935af0c60c011d7213f37c39f43ce088f9436"

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
    output = shell_output("#{bin}/dwarf -c 'print $mac' test")
    assert_equal "magic: 0xfeedfacf (-17958193)", output.lines[1].chomp
  end
end
