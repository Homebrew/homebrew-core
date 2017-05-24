class Libmagic < Formula
  desc "Implementation of the file(1) command"
  homepage "https://www.darwinsys.com/file/"
  url "ftp://ftp.astron.com/pub/file/file-5.31.tar.gz"
  mirror "https://fossies.org/linux/misc/file-5.31.tar.gz"
  sha256 "09c588dac9cff4baa054f51a36141793bcf64926edc909594111ceae60fce4ee"

  bottle do
    sha256 "7b8f1701d7565c1d89de611d2633962d58411fff01027b47327934932bfa2f66" => :sierra
    sha256 "d8481b614f8583f862b18b27dcff69c046e3c6f20d4eddde8d777a3e4be95688" => :el_capitan
    sha256 "2ca4f55351b129933f8625b19958ecc21ce9d301ef18f771572f0bcba484f1e5" => :yosemite
  end

  depends_on :python => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-fsect-man5",
                          "--enable-static"
    system "make", "install"
    (share+"misc/magic").install Dir["magic/Magdir/*"]

    if build.with? "python"
      cd "python" do
        system "python", *Language::Python.setup_install_args(prefix)
      end
    end

    # Don't dupe this system utility
    rm bin/"file"
    rm man1/"file.1"
  end
end
