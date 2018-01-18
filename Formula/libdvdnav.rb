class Libdvdnav < Formula
  desc "DVD navigation library"
  homepage "http://dvdnav.mplayerhq.hu/"
  url "https://download.videolan.org/pub/videolan/libdvdnav/6.0.0/libdvdnav-6.0.0.tar.bz2"
  sha256 "f0a2711b08a021759792f8eb14bb82ff8a3c929bf88c33b64ffcddaa27935618"

  bottle do
    cellar :any
    sha256 "82f7cf986d45b13b3cc57d121dc53d7fa43d628062f978e31723d49778ea8d22" => :high_sierra
    sha256 "1a2a0a5b4f2c349574f830ae5e918ee2788ceb17d2f2856ec507e62226327e28" => :sierra
    sha256 "379d6e135a9e97db494376c0f35e235bced3a3052e60a0fea2a5318730c5d900" => :el_capitan
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
