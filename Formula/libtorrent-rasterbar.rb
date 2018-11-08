class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library by Rasterbar Software"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_1_10/libtorrent-rasterbar-1.1.10.tar.gz"
  sha256 "07b2b391e0d16bc693d793e352338488a0e41f3130b70884bb2e0270ea00b8c2"
  revision 1

  bottle do
    cellar :any
    sha256 "9039792f182a56f9c92f5ba39d3ed2538bb03635c74cc4c838d55d4c29ee7f5c" => :mojave
    sha256 "6ac5e534203c06bd113b61a302f64b9d02c065b967a2ac30276406f44973972d" => :high_sierra
    sha256 "5cc3e874d0543efd80b12b9f769263508d5380b11a25324d5236f68caa8620c4" => :sierra
  end

  head do
    url "https://github.com/arvidn/libtorrent.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "openssl"
  depends_on "python"

  def install
    ENV.cxx11

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-encryption
      --enable-python-binding
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-boost-python=boost_python37-mt
      PYTHON=python3
    ]

    if build.head?
      system "./bootstrap.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
    libexec.install "examples"
  end

  test do
    system ENV.cxx, "-L#{lib}", "-ltorrent-rasterbar",
           "-I#{Formula["boost"].include}/boost",
           "-L#{Formula["boost"].lib}", "-lboost_system",
           libexec/"examples/make_torrent.cpp", "-o", "test"
    system "./test", test_fixtures("test.mp3"), "-o", "test.torrent"
    assert_predicate testpath/"test.torrent", :exist?
  end
end
