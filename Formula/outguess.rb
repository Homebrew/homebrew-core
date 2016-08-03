class Outguess < Formula
  desc "universal steganographic tool"
  homepage "http://www.rbcafe.com/softwares/outguess/"
  url "https://ftp.mirrorservice.org/sites/ftp.wiretapped.net/pub/security/steganography/outguess/outguess-0.2.tar.gz"
  sha256 "2f951ed7b9b9373fae8fe95616d49c83ae246cf53a2b60a82814228515bfa7d6"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    bin.install "outguess"
    man1.install "outguess.1"
  end

  test do
    `outguess`
    assert $?.exitstatus == 1
  end
end
