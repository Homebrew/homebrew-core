class I386ElfBinutils < Formula
  desc "FSF Binutils for i386-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.31.tar.gz"
  sha256 "0ed42f0a02ca20d3b04f05d5417aaba69202dfec6564b30bd0e5680f355c6d87"
  depends_on "gettext" => :build
  depends_on "xz" => :build

  def install
    mkdir "binutils-build" do
      system "../configure", "--target=i386-elf",
                             "--prefix=#{prefix}",
                             "--disable-multilib",
                             "--disable-nls",
                             "--disable-werror"
      system "make", "install"
    end
  end

  test do
    system "i386-elf-ar", "--version"
  end
end
