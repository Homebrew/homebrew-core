class I386ElfGrub < Formula
  desc "GNU GRUB 2 for i386-elf"
  homepage "https://www.gnu.org/software/grub/"
  url "https://ftp.gnu.org/gnu/grub/grub-2.02.tar.xz"
  sha256 "810b3798d316394f94096ec2797909dbf23c858e48f7b3830826b8daa06b7b0f"

  bottle do
    sha256 "e83a6a8d1db4953ef70948e357b46570cddfb4158e82428faa0824946a539be0" => :mojave
    sha256 "1f8657576755199211411b28e9c8ccba6cdb51fa02ab63479a33561c9e26d195" => :high_sierra
    sha256 "9bbce3ac0fc16ed8bcdd1e57190483eb70d81e308d8d4e95733b81bef62319ba" => :sierra
  end

  depends_on "i386-elf-binutils" => :build
  depends_on "i386-elf-gcc" => :build

  resource ("image") do
    url "https://raw.githubusercontent.com/MRNIU/tools/master/kernel.kernel"
    sha256 "ac0e87c8a612fdfd4ce4c7f0a2161b5d156972d757c781cc5690735303861abf"
  end

  def install
    mkdir "build" do
      system "../configure", "--target=i386-elf",
                             "--prefix=#{prefix}",
                             "--program-prefix=i386-elf-",
                             "--disable-werror",
                             "TARGET_CC=i386-elf-gcc",
                             "TARGET_OBJCOPY=i386-elf-objcopy",
                             "TARGET_STRIP=i386-elf-strip",
                             "TARGET_NM=i386-elf-nm",
                             "TARGET_RANLIB=i386-elf-ranlib"
      system "make"
      system "make", "install"
    end
  end

  test do
    resource("image").stage do
      system bin/"i386-elf-grub-file", "--is-x86-multiboot2", "kernel.kernel"
    end
  end
end
