class I386ElfBinutils < Formula
  desc "FSF Binutils for i386-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.31.1.tar.xz"
  sha256 "5d20086ecf5752cc7d9134246e9588fa201740d540f7eb84d795b1f7a93bca86"

  def install
    system "./configure", "--target=i386-elf",
                          "--disable-multilib",
                          "--disable-nls",
                          "--disable-werror",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "f()", shell_output("#{bin}/i386-elf-c++filt _Z1fv")
  end
end
