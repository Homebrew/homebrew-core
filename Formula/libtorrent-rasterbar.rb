class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/libtorrent_1_2_7/libtorrent-rasterbar-1.2.7.tar.gz"
  sha256 "bc00069e65c0825cbe1eee5cdd26f94fcd9a621c4e7f791810b12fab64192f00"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "ebcf3c671f25bf16e9643b647e2dff1339458d7b6b4e28fbde07e0e54abe29fd" => :catalina
    sha256 "68bd2a4ed0dd30a61b4bf5667eb21a01e3bc617a6bcb55a5ea5cdbea8954b50e" => :mojave
    sha256 "1f25a63a7e555b4f4c9f0491e363aa2ba8d5eb134dc3f65a1df6c60cc926c187" => :high_sierra
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

  conflicts_with "libtorrent-rakshasa", because: "they both use the same libname"

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
