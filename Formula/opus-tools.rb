class OpusTools < Formula
  desc "Utilities to encode, inspect, and decode .opus files"
  homepage "https://www.opus-codec.org"
  url "http://downloads.xiph.org/releases/opus/opus-tools-0.1.9.tar.gz"
  sha256 "b1873dd78c7fbc98cf65d6e10cfddb5c2c03b3af93f922139a2104baedb4643a"

  bottle do
    cellar :any
    sha256 "2b0c4de73db22557218c03803b7c27cfb23527f35059aa36240cc12076c95e5a" => :sierra
    sha256 "7bfccafbee68fc61d1a5d8e3ea3d2f99f95876c45ada9570fac5ba08f3916b1a" => :el_capitan
    sha256 "ae51146c28dced90e2a4f0f869bb19a6b442e96727cf655240d3d01f17b51de3" => :yosemite
    sha256 "ea7c44249700b7a2e0d6809f55b9e52b87ece5290aaa9bd4fc73ffd1a30cc38f" => :mavericks
  end

  head do
    url "https://git.xiph.org/opus-tools.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "opus"
  depends_on "flac"
  depends_on "libogg"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
