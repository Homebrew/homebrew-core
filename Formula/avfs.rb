class Avfs < Formula
  desc "Virtual file system that facilitates looking inside archives"
  homepage "https://avf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/avf/avfs/1.1.1/avfs-1.1.1.tar.bz2"
  sha256 "c83eef7f8676db6fed0a18373c433e0ff55af1651246303ebe1181e8ef8bbf3b"

  bottle do
    sha256 "80e240dd2ddab63987b7da1e3a641f5736838e5c648db37e349358aa28bff1c0" => :mojave
    sha256 "4870df9b74a69515a4c3f0d601d6a709c487b985b797780b4cfdf849e899a6af" => :high_sierra
    sha256 "f65036ef7e2db4bfea6c0bc742ea7693fe62eb1afa2c11d3e66297cf932ede91" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on :macos => :sierra # needs clock_gettime
  depends_on "openssl"
  depends_on :osxfuse
  depends_on "xz"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-fuse
      --enable-library
      --with-ssl=#{Formula["openssl"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"avfsd", "--version"
  end
end
