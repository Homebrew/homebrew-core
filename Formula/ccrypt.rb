class Ccrypt < Formula
  desc "Encrypt and decrypt files and streams"
  homepage "https://ccrypt.sourceforge.io/"
  url "https://ccrypt.sourceforge.io/download/ccrypt-1.10.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/c/ccrypt/ccrypt_1.10.orig.tar.gz"
  sha256 "87d66da2170facabf6f2fc073586ae2c7320d4689980cfca415c74688e499ba0"

  bottle do
    rebuild 1
    sha256 "41561da9ecb852e0e704b6c9d6693f1eac65a02d0ff1419eb55b4221550d6aa7" => :sierra
    sha256 "006c8e5eb58e88305dec70559d6d64fd0203881dcaca36db50cbb44d3aaae61b" => :el_capitan
    sha256 "44efc492cc7cf2d4f1061f14fd5aa213517406434c41c96e297d9b4f06d7e1a7" => :yosemite
  end

  conflicts_with "ccat", :because => "both install `ccat` binaries"

  fails_with :clang do
    build 318
    cause "Tests fail when optimizations are enabled"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-lispdir=#{share}/emacs/site-lisp/ccrypt"
    system "make", "install"
    system "make", "check"
  end

  test do
    touch "homebrew.txt"
    system bin/"ccrypt", "-e", testpath/"homebrew.txt", "-K", "secret"
    assert File.exist?("homebrew.txt.cpt")
    assert !File.exist?("homebrew.txt")

    system bin/"ccrypt", "-d", testpath/"homebrew.txt.cpt", "-K", "secret"
    assert File.exist?("homebrew.txt")
    assert !File.exist?("homebrew.txt.cpt")
  end
end
