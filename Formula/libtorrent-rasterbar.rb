class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_2_6/libtorrent-rasterbar-1.2.6.tar.gz"
  sha256 "8f69befe449f7211afc665726d24fde62f019800b060b5c6c9804793929a4407"

  bottle do
    cellar :any
    rebuild 1
    sha256 "806b247874bf4c2b43d16cfe5e7c8f074ec117abede5fa74234dc6c8735e0555" => :catalina
    sha256 "cfb22dfd0ce143aa58d4e7da6b60bc31b2b751a52fb495edcf6cd612d6b62753" => :mojave
    sha256 "b60b41febbc56c8405e2a496c6c97fa16671a3aa27329250c088173222fe214c" => :high_sierra
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
  depends_on "python@3.8"

  conflicts_with "libtorrent-rakshasa", :because => "they both use the same libname"

  def install
    pyver = Language::Python.major_minor_version(Formula["python@3.8"].bin/"python3").to_s.delete(".")
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-encryption
      --enable-python-binding
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-boost-python=boost_python#{pyver}-mt
      PYTHON=python3
      PYTHON_EXTRA_LIBS=#{`#{Formula["python@3.8"].opt_bin}/python3-config --libs --embed`.chomp}
      PYTHON_EXTRA_LDFLAGS=#{`#{Formula["python@3.8"].opt_bin}/python3-config --ldflags`.chomp}
    ]

    if build.head?
      system "./bootstrap.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"

    rm Dir["examples/Makefile*"]
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
