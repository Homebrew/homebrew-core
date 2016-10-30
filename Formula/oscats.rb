class Oscats < Formula
  desc "Computerized adaptive testing system"
  homepage "https://code.google.com/archive/p/oscats/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/oscats/oscats-0.6.tar.gz"
  sha256 "2f7c88cdab6a2106085f7a3e5b1073c74f7d633728c76bd73efba5dc5657a604"
  revision 1

  bottle do
    cellar :any
    sha256 "d08faef8fc25411bfda3c5727a3393a492052cafb684038cf80e951f5949b44c" => :sierra
    sha256 "0c5dc5fdae72d08c43efe3d1053e7409d998054fa1a14431fbe192cf2b77d1f6" => :el_capitan
    sha256 "859a82a1f1211bae6887cdc53c09592a11996964f892048e05c1775cecfad0ce" => :yosemite
    sha256 "4c6ebccd2065ad9f72c9611521cd51b9e529a54c199e9937c86bc77875f5637d" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gsl"
  depends_on "glib"
  depends_on :python => :optional
  depends_on "pygobject" if build.with? "python"

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--enable-python-bindings" if build.with? "python"
    system "./configure", *args
    system "make", "install"
  end
end
