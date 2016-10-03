class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library by Rasterbar Software"
  homepage "http://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_1/libtorrent-rasterbar-1.1.0.tar.gz"
  sha256 "2713df7da4aec5263ac11b6626ea966f368a5a8081103fd8f2f2ed97b5cd731d"
  revision 1

  bottle do
    cellar :any
    sha256 "4f961f0bb04717b1702e468c79863e9712be95d2b3f32e2af9d152e77dfaf51e" => :sierra
    sha256 "5050d8aac4b229d7af963a06703010ffc7efabe8fe6aa6096388052e0c89d1e2" => :el_capitan
    sha256 "13489f01602f83b27ca3d3656ec555141521eed60d900b0e027b7e4eb610b693" => :yosemite
    sha256 "6b79702c81dd8b40306b7d195693de36caeceab59038f6740107bcff96376a18" => :mavericks
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
  depends_on "boost@1.61"
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
