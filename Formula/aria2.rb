class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.33.1/aria2-1.33.1.tar.xz"
  sha256 "2539e4844f55a1f1f5c46ad42744335266053a69162e964d9a2d80a362c75e1b"

  bottle do
    cellar :any_skip_relocation
    sha256 "1992d39c07ad9de977413b71dedbc78cc83943dc2597a159ab0fc15784310dfd" => :high_sierra
    sha256 "464a54003a4f8d177065113650f4da67b3fd608c219640a0088ccc955759e43c" => :sierra
    sha256 "596311357d76da2db291322804db854a8dfb04d89d5b8f0e45ae09c939bc7373" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libssh2" => :optional

  needs :cxx11

  def install
    ENV.cxx11

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
    system "#{bin}/aria2c", "https://brew.sh/"
    assert_predicate testpath/"index.html", :exist?, "Failed to create index.html!"
  end
end
