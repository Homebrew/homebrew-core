class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.27.1/aria2-1.27.1.tar.xz"
  sha256 "c09627ef31602cfdfa7c9925a6c3b05fe7d2097d83f42dcfdef68664bd106f08"

  bottle do
    cellar :any_skip_relocation
    sha256 "a93693514d5d9bd0fa82243f509de5f65b4a833e4d5b873f04f3d7e68963c411" => :sierra
    sha256 "b4678ad64b289d436e12d9863b2bd4b12ebdcf6821e1db52650da293578ee7c3" => :el_capitan
    sha256 "b73b02f655a5de46d70f7576a7c3abfc167feadcebee2cf41a168c44c7ba3b08" => :yosemite
    sha256 "3d7a7a9d5131db45170cb8a4450043dcae180d5169e825d1e2d5b88a163e3c0f" => :mavericks
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
