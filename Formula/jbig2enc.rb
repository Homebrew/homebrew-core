class Jbig2enc < Formula
  desc "JBIG2 encoder (for monochrome documents)"
  homepage "https://github.com/agl/jbig2enc"
  url "https://github.com/agl/jbig2enc/archive/0.29.tar.gz"
  sha256 "bfcf0d0448ee36046af6c776c7271cd5a644855723f0a832d1c0db4de3c21280"
  license "Apache-2.0"
  revision 2
  head "https://github.com/agl/jbig2enc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6a83bb4c38af3d7c863c95fb2220ba0bb09a6e6d15d3f5bcb77dba3cad083ebd"
    sha256 cellar: :any,                 arm64_monterey: "31e2eea748f66cfe91745fe4726d2cc152a198db95d0cc36ca3d6252b6e95b1a"
    sha256 cellar: :any,                 arm64_big_sur:  "36eff0c93fdb1139b771f4c81a03c8b8c32cee1674bd938374e06cc985620e9f"
    sha256 cellar: :any,                 ventura:        "d77d6707c1514d5ab17411c0027a71190546f43de342e3c970c9693cb3a2cfb6"
    sha256 cellar: :any,                 monterey:       "89f7d28906c21b059edb10a24fce102b31575ab6b0ab51eda8cf4bcb96bdd503"
    sha256 cellar: :any,                 big_sur:        "0270c51d95e2674a2d2b03d8e98737e8a3da6bf890757e4c55663315c0a728e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3113143ac93d502f01304f838e5c73bd96366a08dfd79109730965de9e583c9a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "leptonica"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
