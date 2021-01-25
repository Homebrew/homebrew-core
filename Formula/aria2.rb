class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.35.0/aria2-1.35.0.tar.xz"
  sha256 "1e2b7fd08d6af228856e51c07173cfcf987528f1ac97e04c5af4a47642617dfd"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any
    sha256 "05ea0971d6834d9dc50df6a6ca62978ce0f8bf324758225f9d3df091b60fc875" => :big_sur
    sha256 "3db6c6a53e4bfd72eec10dc53179c424f2e72f1321c3f96b1b1b0e8740790af1" => :arm64_big_sur
    sha256 "9cc5e04be8b0a58d1f2b60b8abfc636168edbf23e7018003c40f1dd6952aab0c" => :catalina
    sha256 "761836ac608eb0a59d4a6f6065860c0e809ce454692e0937d9d0d89ad47f3ce4" => :mojave
    sha256 "70cc7566a23c283015368f92dfeaa0d119e53cfc7c1b2276a73ff9f6167b529d" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libssh2"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@1.1"
  end

  def install
    ENV.cxx11

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-libssh2
      --without-gnutls
      --without-libgmp
      --without-libnettle
      --without-libgcrypt
    ]
    on_macos do
      args << "--with-appletls"
      args << "--without-openssl"
    end
    on_linux do
      args << "--without-appletls"
      args << "--with-openssl"
    end

    system "./configure", *args
    system "make", "install"

    bash_completion.install "doc/bash_completion/aria2c"
  end

  test do
    system "#{bin}/aria2c", "https://brew.sh/"
    assert_predicate testpath/"index.html", :exist?, "Failed to create index.html!"
  end
end
