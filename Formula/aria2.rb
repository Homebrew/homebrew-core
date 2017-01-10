class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.30.0/aria2-1.30.0.tar.xz"
  sha256 "bf6c5366d11d2a6038c8e19f01f9b874041793aaf317e0206120e3e8c9c431f6"

  bottle do
    cellar :any_skip_relocation
    sha256 "39877f689a34f77248fe8c468b72d25f529862b6721ca3d1a508fddb69fd8dfb" => :sierra
    sha256 "651f999939e3574fa50b8c508c959e60db5897dc4f208cd7d96b6f9c3a876906" => :el_capitan
    sha256 "b6f64107b52dfc54a50b96c3d12fbe96f4757f52e510357fc11f2c64fac08b43" => :yosemite
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
