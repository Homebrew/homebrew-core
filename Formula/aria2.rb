class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.32.0/aria2-1.32.0.tar.xz"
  sha256 "546e9194a9135d665fce572cb93c88f30fb5601d113bfa19951107ced682dc50"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a0bc8716a5ad5caa8c51b3c7536a111ed41b980b46c845230634e865931182c" => :sierra
    sha256 "0b09dab0ab161a74b823c9b0300e7dc136e4eda9b0d3ef38498202b57f9b32ba" => :el_capitan
    sha256 "4385913e1f2d5554a2625fed43b2a6a4033e78b0ea484f8f468e2ea30f9fcc17" => :yosemite
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
    assert File.exist?("index.html"), "Failed to create index.html!"
  end
end
