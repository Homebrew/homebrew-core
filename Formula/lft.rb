class Lft < Formula
  desc "Layer Four Traceroute (LFT), an advanced traceroute tool"
  homepage "https://pwhois.org/lft/"
  url "https://pwhois.org/dl/index.who?file=lft-3.78.tar.gz"
  sha256 "000575891b4094319a56d395c0ec576651fe76b251596ab19d3eb2e5f8d4bf78"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf7e88c74aeb7ffaabd9e417ec4ae308ab590d9f3504ff91affa2310c5b64fda" => :sierra
    sha256 "ba0daf2f7061bb4627c931ffc8f5d80f9941727fd575576e37bca6acf7e65904" => :el_capitan
    sha256 "b7356272883fe608b6c5f56ed4ac468edc234f842a7f0307079720f06226a886" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lft -v 2>&1")
  end
end
