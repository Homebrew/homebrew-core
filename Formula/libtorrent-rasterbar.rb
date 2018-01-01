class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library by Rasterbar Software"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_1_6/libtorrent-rasterbar-1.1.6.tar.gz"
  sha256 "b7c74d004bd121bd6e9f8975ee1fec3c95c74044c6a6250f6b07f259f55121ef"

  bottle do
    cellar :any
    sha256 "f246cd55b9798e90a8658f6bd105aa594a6527008b4de7ed1491f9ef3f9570c8" => :high_sierra
    sha256 "dc6442a8e547e15c465bd1203b96da165fdd7087e79133f22cc266fcf43f47e7" => :sierra
    sha256 "c84078547bb3a00bd0471c3a84de980776373b0c13475a12cb78b841c2a89175" => :el_capitan
  end

  head do
    url "https://github.com/arvidn/libtorrent.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on :python => :optional
  depends_on "boost"
  depends_on "boost-python" if build.with? "python"

  def install
    ENV.cxx11
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--disable-silent-rules",
            "--enable-encryption",
            "--prefix=#{prefix}",
            "--with-boost=#{Formula["boost"].opt_prefix}"]

    # Build python bindings requires forcing usage of the mt version of boost_python.
    if build.with? "python"
      args << "--enable-python-binding"
      args << "--with-boost-python=boost_python-mt"
    end

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
           "-I#{Formula["boost"].include}/boost", "-lboost_system",
           libexec/"examples/make_torrent.cpp", "-o", "test"
    system "./test", test_fixtures("test.mp3"), "-o", "test.torrent"
    assert_predicate testpath/"test.torrent", :exist?
  end
end
