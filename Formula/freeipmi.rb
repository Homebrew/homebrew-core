class Freeipmi < Formula
  desc "In-band and out-of-band IPMI (v1.5/2.0) software"
  homepage "https://www.gnu.org/software/freeipmi/"
  url "https://ftpmirror.gnu.org/freeipmi/freeipmi-1.5.4.tar.gz"
  mirror "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.5.4.tar.gz"
  sha256 "6504a775d5d818c9353ecc7b2697596b29f8bc05e917b6f70157492fbddd1fd5"

  bottle do
    sha256 "516e6f774f5f67455a014714c537ca3b79311911071639a9f30677d7bf635376" => :sierra
    sha256 "71d8847c4317468e98ef2d90655c22310b9b5bed18d06660bf7800948f95a316" => :el_capitan
    sha256 "d60bfed8bc72a489ae58594d57e2f2d3880ab1406567103ec79cb5daec18d147" => :yosemite
    sha256 "11ff07e0c66aa0184826a993f42e057283fb99cc49c4bbc852c5839e7849fd1c" => :mavericks
  end

  depends_on "argp-standalone"
  depends_on "libgcrypt"

  def install
    system "./configure", "--prefix=#{prefix}"
    # This is a big hammer to disable building the man pages
    # It breaks under homebrew's build system and I'm not sure why
    inreplace "man/Makefile", "install: install-am", "install:"
    system "make", "install"
  end

  test do
    system sbin/"ipmi-fru", "--version"
  end
end
