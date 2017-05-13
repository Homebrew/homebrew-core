class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library by Rasterbar Software"
  homepage "http://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_1_3/libtorrent-rasterbar-1.1.3.tar.gz"
  sha256 "44196a89932c26528f5db19289d0f0f4130730a61dccc61c9f1eac9ad3e881d8"

  bottle do
    cellar :any
    sha256 "3dd3f762a1f2752ade68b556a2fbef59a464483f5145078cc88fbdd35015c280" => :sierra
    sha256 "2306afa8195a418c89f8e9e0cd13532d5a5a418b924ccbb2d516691c48207b8c" => :el_capitan
    sha256 "cc73f24fa62e4759a493a7c7c3c7564b2c70ad3f1c4720f37b24f5b83f8098d8" => :yosemite
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
  depends_on "geoip" => :optional
  depends_on "boost"
  depends_on "boost-python" if build.with? "python"

  def install
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

    if build.with? "geoip"
      args << "--enable-geoip"
      args << "--with-libgeoip"
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
    File.exist? testpath/"test.torrent"
  end
end
