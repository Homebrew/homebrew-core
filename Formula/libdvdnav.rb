class Libdvdnav < Formula
  desc "DVD navigation library"
  homepage "https://www.videolan.org/developers/libdvdnav.html"
  url "https://download.videolan.org/pub/videolan/libdvdnav/6.0.1/libdvdnav-6.0.1.tar.bz2"
  sha256 "e566a396f1950017088bfd760395b0565db44234195ada5413366c9d23926733"

  bottle do
    cellar :any
    sha256 "ab454ef5953ec2a7df13971011aaf147fb3b16b511ddedea0a944bde6906ec66" => :catalina
    sha256 "b6ca35590413d5f66dc51ec166f8210f84d7567edae74960833c9631cf10fba7" => :mojave
    sha256 "dbb5f957591d50227177af6eab54c242b965bef4b89df35aff0bb25eac347334" => :high_sierra
  end

  head do
    url "https://git.videolan.org/git/libdvdnav.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libdvdread"

  def install
    system "autoreconf", "-if" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
