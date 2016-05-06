class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.22.0/aria2-1.22.0.tar.xz"
  sha256 "ac3fb3f33a76ce22f968ace293445ef64c201b0ae43aef21e664e4b977e34f89"

  bottle do
    cellar :any_skip_relocation
    sha256 "724b7aa74bd3e7cd470162adf27ab5bd1d1369a16108ddd5def2dc1ab99fac95" => :el_capitan
    sha256 "83b3f974bc53c3b59f8bf32fc84c855e24e794e0e0350f7477b4773e6e6a2fa0" => :yosemite
    sha256 "8fc117fbdf3470cf3be39573b0553728538742a45776dc6a3dbfedef30b430e1" => :mavericks
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
