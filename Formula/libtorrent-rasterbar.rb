class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library by Rasterbar Software"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_1_7/libtorrent-rasterbar-1.1.7.tar.gz"
  sha256 "8133bf683308decc24da22aff17437e36c522d8959bcf934e94cf7a3a567f3a9"

  bottle do
    cellar :any
    sha256 "5b4a43e6bb49e3833e10f531681d4841eac8175036a9ecaad6b54f7ab85ca65f" => :high_sierra
    sha256 "760221d15d7d1974ae23d684d040738b7053ddafa3177991e59f77d610ea6165" => :sierra
    sha256 "92872796f8a352da0d68a5bca3c8c897097cc9614be320cc34728e4c3024dc65" => :el_capitan
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

  # Remove for > 1.1.7
  # Upstream commit from 11 Apr 2018 "fix boost-1.67 build"
  patch do
    url "https://github.com/arvidn/libtorrent/commit/64d6b49004.patch?full_index=1"
    sha256 "97987e7ec1100c3ae9a0a0b82c1c2237672f15d2abc3b1707c6c8b328c37ce32"
  end

  # Remove for > 1.1.7
  # Upstream commit from 12 Apr 2018 "another boost-1.67 build fix"
  patch do
    url "https://github.com/arvidn/libtorrent/commit/9cd0ae67e7.patch?full_index=1"
    sha256 "185d59167d89884849408e7ff831badd3fbf4048b48b634e847134b4a8033299"
  end

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
