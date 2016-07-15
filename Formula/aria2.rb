class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.25.0/aria2-1.25.0.tar.xz"
  sha256 "ff89eb4c76cfc816a6f5abc7dfd416cc3f339e7d02c761f822fa965a18cf0d35"

  bottle do
    cellar :any_skip_relocation
    sha256 "45e25bc07de1dde58b90b45c5af8988e4cbf4a4f1208c8ed5067d0d81f58b630" => :el_capitan
    sha256 "dced3844d85fb2da818606a69a7818a6ab538bf301395b66ed8f09dc12fe8c0b" => :yosemite
    sha256 "33fc83a43eba0477bccccf32735d21c06fa81afeb611cd8868242d5753458e3c" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libssh2" => :optional

  needs :cxx11

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
