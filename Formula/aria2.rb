class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.26.1/aria2-1.26.1.tar.xz"
  sha256 "f4e64e9754af5e1c0ee1ee2a50c5fa5acbc180855909209c2ce0111e86c9a801"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4ccabaf6898aa3d51a64b6e2a9bfaf49319bb3d7fb4b69142133f747c58cc2c" => :sierra
    sha256 "deda73ba1f37369b90ad59ae0afd168859e7a90391dd18968d14efa15194b5b6" => :el_capitan
    sha256 "0f09834556a18d907afd845e3002b74ca4d47f6ee3ca6788c45abeec1f87f0ee" => :yosemite
    sha256 "7bcca09fbf53ee86c9b7727bb77793702eb247931f32d06f64a7b815a383053a" => :mavericks
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
    system "#{bin}/aria2c", "http://brew.sh"
    assert File.exist?("index.html"), "Failed to create index.html!"
  end
end
