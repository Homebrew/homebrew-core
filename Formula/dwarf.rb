class Dwarf < Formula
  desc "Object file manipulation tool"
  homepage "https://github.com/elboza/dwarf-ng/"
  url "https://github.com/elboza/dwarf-ng/archive/dwarf-0.4.0.tar.gz"
  sha256 "a64656f53ded5166041ae25cc4b1ad9ab5046a5c4d4c05b727447e73c0d83da0"
  license "GPL-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0bd56303a2a78e899a035597b779d5a3701f911ebfdf586d4a41d660f13253fe"
    sha256 cellar: :any,                 arm64_big_sur:  "30b7f9852b68c70d6e8e07c0de3e9075a4e0edd0facc219970de6535e5931b4d"
    sha256 cellar: :any,                 monterey:       "cf1b9df9782554d32d6827b89b29195ed7f391a37cd0b9cbab9a63e0ceacec20"
    sha256 cellar: :any,                 big_sur:        "b0bec07c54898e3506e249b3c18fde361772367f1e2d8cc2ee6726a678aea7cd"
    sha256 cellar: :any,                 catalina:       "1d0e1d803ab771d58a56cd52939d01b7c9e1a8474cb80c21b2251320340e5dc2"
    sha256 cellar: :any,                 mojave:         "c10f3ccbb2dc59b7c76c9dd46a71f1e41d7c7faa8fab5f4326599b3a5467c770"
    sha256 cellar: :any,                 high_sierra:    "92db022169f222a0ce002e6c20e6256cc5636f61c1e6fa1c44b56481c5a2422d"
    sha256 cellar: :any,                 sierra:         "dbc5a7043b5888284ddab1d97b57406fc6c24d71c205a54482e3ef0e442e20fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15de6388ac637850379a4b2cf37e2089b97b96cf0df0ed536f3c7b7b19a9c641"
  end

  depends_on "flex"
  depends_on "readline"

  uses_from_macos "bison"

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
    on_macos do
      output = shell_output("#{bin}/dwarf -c 'pp $mac' test")
      assert_equal "magic: 0xfeedfacf (-17958193)", output.lines[0].chomp
    end
    on_linux do
      # pp may not be installed on Linux, test something else
      assert_match "main header: elf", shell_output("#{bin}/dwarf -p test")
    end
  end
end
