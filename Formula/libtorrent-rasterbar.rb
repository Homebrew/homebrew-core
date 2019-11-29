class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_2_2/libtorrent-rasterbar-1.2.2.tar.gz"
  sha256 "e579261d7f0acbe82e9b4ce703cb721627cb8075023f8a26405992f489bc6202"

  bottle do
    cellar :any
    sha256 "8b244067c5402516ed9430fb06fb007bd8895de3b7fb8c48e88af1fce992849a" => :catalina
    sha256 "f93dc11cc55befe32f43c6ade5dbc6eb5b65e9f70442b80d26e948306e1964f8" => :mojave
    sha256 "bb13af8b8c7495fb1fb3c07a38c690687a78af3164d26681ca3f81511f0c3277" => :high_sierra
    sha256 "842c4c7e9a5e50ceb7bdc74149933e8ae79c41ca2e0c6e867b4450046221dc92" => :sierra
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
  depends_on "openssl@1.1"
  depends_on "python"

  def install
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
    system ENV.cxx, "-std=c++11", "-I#{Formula["boost"].include}/boost",
                    "-L#{lib}", "-ltorrent-rasterbar",
                    "-L#{Formula["boost"].lib}", "-lboost_system",
                    "-framework", "SystemConfiguration",
                    "-framework", "CoreFoundation",
                    libexec/"examples/make_torrent.cpp", "-o", "test"
    system "./test", test_fixtures("test.mp3"), "-o", "test.torrent"
    assert_predicate testpath/"test.torrent", :exist?
  end
end
