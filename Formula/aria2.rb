class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.29.0/aria2-1.29.0.tar.xz"
  sha256 "1a64d023e75bf61c751609ef0df198596f785f1abc371672a75d5b09bd91c82e"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b9b26c34ee480796f6fe22938b78202d130ffb7758798e5ac53b5f896d6c996" => :sierra
    sha256 "95e6fc4f2720d4db6724075f6e79eae0e3c1d461406b20f96857a8ee53a1c852" => :el_capitan
    sha256 "9d0ada6bf72936be11e6d56941474d9e9b63e30e09bc7b9940190bc65ae5662e" => :yosemite
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
