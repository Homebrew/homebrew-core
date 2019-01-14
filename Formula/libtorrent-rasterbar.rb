class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library by Rasterbar Software"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/libtorrent_1_1_11/libtorrent-rasterbar-1.1.11.tar.gz"
  sha256 "7c23deba7fa279825642307587609d51c9935ac7606e0ef2f2d0ba10728b5847"

  bottle do
    cellar :any
    sha256 "ce18f1e7cb6bc5be735c1b9388995312d92781d0f543e88d7d1c0c2bdbfcc643" => :mojave
    sha256 "1950410d90d2e1b5342fd917ba498abbb3caeb31080a6f6908de80988a9cc06e" => :high_sierra
    sha256 "45bdf1f92a889fb71b61213e65a61aa17245120cbd4e4e08b2fae2215bf69da4" => :sierra
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
