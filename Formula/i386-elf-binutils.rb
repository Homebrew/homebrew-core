class I386ElfBinutils < Formula
  desc "FSF Binutils for i386-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.32.tar.gz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.32.tar.gz"
  sha256 "9b0d97b3d30df184d302bced12f976aa1e5fbf4b0be696cdebc6cca30411a46e"

  bottle do
    sha256 "3a3d88a8b8d33ae13854cae4ccb7120b277862ae42e863acee9926744294ed0c" => :catalina
    sha256 "deef284fbb0b50aeafdaf9312c56bed4f3ca9571374f4174ab6f877bcfdab3e0" => :mojave
    sha256 "f382f13d45f7d71ca9471d78aae6d03af5f1622ede5346cb27014cf36abf7b29" => :high_sierra
    sha256 "992fa92fb007f81e25469a479730b560d84d06c6eedaac1b989b929ee6609c57" => :sierra
  end

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
