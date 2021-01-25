class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/libtorrent-1.2.10/libtorrent-rasterbar-1.2.10.tar.gz"
  sha256 "d0dd30bdc3926587c4241f4068d8e39628a6c1f9f6cf53195f0e9bc90017befb"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :head
    regex(/^libtorrent[._-]v?(\d+(?:[-_.]\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "92d140b497497ac2edc980534ff710ff50b99e967c2a01fe0c952c51a0bf3aeb" => :big_sur
    sha256 "566168949b3c30d457469e9e1a6ee366aef3e8a3f72191b36cfcd87033834b28" => :arm64_big_sur
    sha256 "2b5460c509171200053dbb6d0eb45b71737695239beff530d63c55265c89fec5" => :catalina
    sha256 "593dae5994fb2e71c44f0150196d8cb719872b15e6212a8d669b1ed43c4f8f90" => :mojave
    sha256 "9f140786725e1a24971d5d3a99ff77cb35ec713f6fb6fd871b40633d4a322ea3" => :high_sierra
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
  depends_on "python@3.9"

  conflicts_with "libtorrent-rakshasa", because: "they both use the same libname"

  def install
    pyver = Language::Python.major_minor_version(Formula["python@3.9"].bin/"python3").to_s.delete(".")
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
      PYTHON_EXTRA_LIBS=#{`#{Formula["python@3.9"].opt_bin}/python3-config --libs --embed`.chomp}
      PYTHON_EXTRA_LDFLAGS=#{`#{Formula["python@3.9"].opt_bin}/python3-config --ldflags`.chomp}
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
