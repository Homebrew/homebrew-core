class I686ElfGrub < Formula
  desc "GNU GRUB bootloader for i686-elf"
  homepage "https://savannah.gnu.org/projects/grub"
  url "https://ftpmirror.gnu.org/gnu/grub/grub-2.12.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/gnu/grub/grub-2.12.tar.xz"
  sha256 "f3c97391f7c4eaa677a78e090c7e97e6dc47b16f655f04683ebd37bef7fe0faa"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "e22e948d3c138afe51718fa03e908d0dafcc149ae3a027f76627e1482523523d"
    sha256 arm64_sequoia: "d23447673032cf2864040cebb681a8b6ac490b5ad8003d6408a72335a16f8204"
    sha256 arm64_sonoma:  "1f7b81cb7e658c58ce8082f1c30c2a2b4096a576eb6f246637f6d9c0d31f4d78"
    sha256 sonoma:        "5e341e336a81fda461e2bbf400b025ed927874225fcb1357495cc357a25a73d5"
    sha256 arm64_linux:   "5533d33e3960b1f4a494ff0a0028c1057ffcc3f750ba5f38c41cce6aa74f6c31"
    sha256 x86_64_linux:  "00052bc3758ba64638f3f1a34c2de0186a917fcd50d6ed4907b4db7786429573"
  end

  depends_on "gawk" => :build
  depends_on "help2man" => :build
  depends_on "i686-elf-binutils" => :build
  depends_on "i686-elf-gcc" => [:build, :test]
  depends_on "texinfo" => :build
  depends_on "xz"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "python" => :build

  on_macos do
    depends_on "gettext"
  end

  def target
    "i686-elf"
  end

  def install
    touch buildpath/"grub-core/extra_deps.lst"

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
