class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library by Rasterbar Software"
  homepage "http://www.libtorrent.org/"
  revision 1

  stable do
    url "https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_1_4/libtorrent-rasterbar-1.1.4.tar.gz"
    sha256 "ccf42367803a6df7edcf4756d1f7d0a9ce6158ec33b851b3b58fd470ac4eeba6"

    # Fix compilation with Boost >= 1.65, remove in next release
    patch do
      url "https://patch-diff.githubusercontent.com/raw/arvidn/libtorrent/pull/2146.patch?full_index=1"
      sha256 "be5c98a435a047027d1bad667876322b0d8fc55c8265131368072e93b6729a18"
    end
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "5f9125a9d3c71eb237da458eae5b6cc0d5bdd75812122765dcdf913ac77252c6" => :high_sierra
    sha256 "86ff2717a99856d38bf10f56229b10bbec6bcd1b74e3086e98059be613ac26be" => :sierra
    sha256 "4b2346c9afc763d3703e2268471e5fe28e2631e56a73ffc50eaa63ae82353d7a" => :el_capitan
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
    assert_predicate testpath/"test.torrent", :exist?
  end
end
