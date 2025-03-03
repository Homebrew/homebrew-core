class I686ElfGrub < Formula
  desc "GNU GRUB bootloader for i686-elf"
  homepage "https://savannah.gnu.org/projects/grub"
  url "https://ftp.gnu.org/gnu/grub/grub-2.12.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/gnu/grub/grub-2.12.tar.xz"
  sha256 "f3c97391f7c4eaa677a78e090c7e97e6dc47b16f655f04683ebd37bef7fe0faa"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "5e69ba0912b4af63d9096b700661f94d7eee58f29cc6918a9bddbd1464ba6ab4"
    sha256 arm64_sonoma:  "589a6326426f6af516b6f4e9c5de899d0e04e65da8e6818be289c0773b79f727"
    sha256 arm64_ventura: "6019c03071dfb8b6317748ab2179c9db42f0a5fb5bc99e6beceb2f6f45c0a3a2"
    sha256 sonoma:        "3016d288f6ea2fd6493e4217ce393b063615b95581fc4cd1c24579f8801bb019"
    sha256 ventura:       "92b92f9ff2d8fdb59fe50b96556d481d3d247639e0354cf03eac74abf2827f6f"
    sha256 x86_64_linux:  "6b00321d73386ac1e2c3a338fd6ea69b509bf0bd1bf6ea2025ff0a7740fc983a"
  end

  depends_on "help2man" => :build
  depends_on "i686-elf-binutils" => :build
  depends_on "i686-elf-gcc" => [:build, :test]
  depends_on "objconv" => :build
  depends_on "texinfo" => :build
  depends_on "gettext"
  depends_on "xorriso"
  depends_on "xz"
  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "python" => :build

  def target
    "i686-elf"
  end

  def install
    ENV.append_to_cflags "-Wno-error=incompatible-pointer-types"

    mkdir "build" do
      args = %W[
        --disable-werror
        --target=#{target}
        --prefix=#{prefix/target}
        --bindir=#{bin}
        --libdir=#{lib/target}
        --with-platform=pc
        --program-prefix=#{target}-
      ]

      system "../configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"boot.c").write <<~C
      __asm__(
        ".align 4\\n"
        ".long 0x1BADB002\\n"
        ".long 0x0\\n"
        ".long -(0x1BADB002 + 0x0)\\n"
      );
    C
    system Formula["#{target}-gcc"].bin/"#{target}-gcc", "-c", "-o", "boot", "boot.c"
    system bin/"#{target}-grub-file", "--is-x86-multiboot", "boot"
  end
end
