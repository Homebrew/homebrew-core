class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library by Rasterbar Software"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_1_8/libtorrent-rasterbar-1.1.8.tar.gz"
  sha256 "6bbf8fd0430e27037b09a870c89cfc330ea41816102fe1d1d16cc7428df08d5d"

  bottle do
    cellar :any
    sha256 "1280b22567f54fa05bcd358464ed03f5c12f07ea23f9fc5127b72e1b6ccf70ca" => :high_sierra
    sha256 "4c6c1563de89fa732ea42d49500d42543218fd51242464049801dc2a4da99bf8" => :sierra
    sha256 "b96a59b3ce98462fb748a5fa6260c1a9157554515e38cf025d14972bb17ffc15" => :el_capitan
  end

  head do
    url "https://github.com/arvidn/libtorrent.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  deprecated_option "with-python" => "with-python@2"

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "python@2" => :optional
  depends_on "boost"
  depends_on "boost-python" if build.with? "python@2"

  def install
    ENV.cxx11
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--disable-silent-rules",
            "--enable-encryption",
            "--prefix=#{prefix}",
            "--with-boost=#{Formula["boost"].opt_prefix}"]

    # Build python bindings requires forcing usage of the mt version of boost_python.
    if build.with? "python@2"
      args << "--enable-python-binding"
      args << "--with-boost-python=boost_python27-mt"
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
