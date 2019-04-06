class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library by Rasterbar Software"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/libtorrent_1_1_11/libtorrent-rasterbar-1.1.11.tar.gz"
  sha256 "7c23deba7fa279825642307587609d51c9935ac7606e0ef2f2d0ba10728b5847"
  revision 1

  bottle do
    cellar :any
    sha256 "53d91bed31cef91eb32b80c67adca1ea6e97206d15415210b4de602164cba7fd" => :mojave
    sha256 "4f128c474c9e20216448c9c4b04cee3cf382c57455a9acf83154518c0c0c2d07" => :high_sierra
    sha256 "fa8e3ed74f54270abcc6f46e13c70590b1ed2556fc46ebeba8e3e9e2f2c0334d" => :sierra
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
