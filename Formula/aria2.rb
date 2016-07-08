class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.24.0/aria2-1.24.0.tar.xz"
  sha256 "35a496d2704ffb07e0b0dcac16c6d9b2854327967f984218517403d187f7bf37"

  bottle do
    cellar :any_skip_relocation
    sha256 "77dd14e86e57fec131c47d1c10a7902718dd70cbacd554bf708a0b255c21dd1c" => :el_capitan
    sha256 "6eb43cd211c055f4c72685eafcfcc46ee60ee4d98f39aed88c2e5f58fa80055e" => :yosemite
    sha256 "7ef44aedb39d2c0ab0546b51483da694f3813c902b6e4aa4c9c968b062321707" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libssh2" => :optional

  needs :cxx11

  # Fix compile error on OS X
  patch do
    url "https://github.com/aria2/aria2/commit/1e59e357af626edc870b7f53c1ae8083658d0d1a.diff"
    sha256 "05c78b58cc78ba6b766da96cac42e3c87051561af7309fb19881a43f30ce6951"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-appletls
      --without-openssl
      --without-gnutls
      --without-libgmp
      --without-libnettle
      --without-libgcrypt
    ]

    args << "--with-libssh2" if build.with? "libssh2"

    system "./configure", *args
    system "make", "install"

    bash_completion.install "doc/bash_completion/aria2c"
  end

  test do
    system "#{bin}/aria2c", "http://brew.sh"
    assert File.exist? "index.html"
  end
end
