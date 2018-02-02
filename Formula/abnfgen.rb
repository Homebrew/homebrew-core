class Abnfgen < Formula
  desc "Quickly generate random documents that match an ABFN grammar"
  homepage "http://www.quut.com/abnfgen/"
  url "http://www.quut.com/abnfgen/abnfgen-0.18.tar.gz"
  sha256 "223b872fab2418bcd88917109948914af7cca5c17aba453aa519b15fa5c4dd28"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb10a0bd2410bcd5ecb53ee7c39798b1a8d87a8ac69ee11de3444c1f0af458d2" => :high_sierra
    sha256 "31c28287fdf41f1c5767a267343c387b0208e615da3616877c8c6a1c694974af" => :sierra
    sha256 "ac1d3849426bec85a2b5eaba4bac04111aed9c118fc9c76278ffeba2b42cd016" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"grammar").write 'ring = 1*12("ding" SP) "dong" CRLF'
    system "#{bin}/abnfgen", (testpath/"grammar")
  end
end
