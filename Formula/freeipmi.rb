class Freeipmi < Formula
  desc "In-band and out-of-band IPMI (v1.5/2.0) software"
  homepage "https://www.gnu.org/software/freeipmi/"
  url "https://ftpmirror.gnu.org/freeipmi/freeipmi-1.5.4.tar.gz"
  mirror "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.5.4.tar.gz"
  sha256 "6504a775d5d818c9353ecc7b2697596b29f8bc05e917b6f70157492fbddd1fd5"

  bottle do
    sha256 "10175ab2910290da06778de67caba1cccdc508326fb4041398b18504fa6eac1b" => :sierra
    sha256 "84788ec75638ec29da7aae09a2a893bed7195a7b6da2f075805e9d1098a44783" => :el_capitan
    sha256 "16c84f699055978e35a434cf0d4ac6095b307adfce98ab9cab592b8f5a3effbd" => :yosemite
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
