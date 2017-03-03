class Binutils < Formula
  desc "FSF Binutils for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftpmirror.gnu.org/binutils/binutils-2.28.tar.gz"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.28.tar.gz"
  sha256 "cd717966fc761d840d451dbd58d44e1e5b92949d2073d75b73fccb476d772fcf"

  bottle do
    sha256 "1293c3cf47169fe0936144e8f7c045b60531ab930ba790f211ac122b5148267a" => :sierra
    sha256 "094dab865dacf4c365a85b0f17e46c8e22621bd36d1e0fbebe42c9c44c66d822" => :el_capitan
    sha256 "18ca38f5b11315bdc250cb684a7f964af58dc8927b4fa1fb83dbc69a7e965060" => :yosemite
    sha256 "f439d283e39ec5ea5f24bd801ad1dbb03df109e8290d75714551dbe034785e7a" => :mavericks
  end

  # No --default-names option as it interferes with Homebrew builds.

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--program-prefix=g",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}",
                          "--disable-werror",
                          "--enable-interwork",
                          "--enable-multilib",
                          "--enable-64-bit-bfd",
                          "--enable-targets=all"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "main", shell_output("#{bin}/gnm #{bin}/gnm")
  end
end
