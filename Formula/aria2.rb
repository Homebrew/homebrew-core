class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.36.0/aria2-1.36.0.tar.xz"
  sha256 "58d1e7608c12404f0229a3d9a4953d0d00c18040504498b483305bcb3de907a5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_monterey: "74859913b0f8dc82fede202f5b6cb3384202e76887549addc050009e4d277aec"
    sha256 cellar: :any, arm64_big_sur:  "22b11ee6f82f8d693fb2f6c0dd90a81174033640974003e63e4e8f98fbd3f145"
    sha256 cellar: :any, monterey:       "ab509067c72eb555b1583189054622744f39e344e1ee51bfd91c3102167be95b"
    sha256 cellar: :any, big_sur:        "8960d7b6b56fb29e020fb96da5305c3340d266f3e5e0c552248759e8c6169244"
    sha256 cellar: :any, catalina:       "1e9db3f9fd405ed7a303b89379c2a8f3f01c5f5aa92cfbc8ae560c4e28618f8e"
    sha256 cellar: :any, mojave:         "3ecd30ea4573748ec438182dbba6fad002c1465da7ef9f7a32f227fdeddde464"
    sha256               x86_64_linux:   "c7dacb09aaa9eb22baf6ee6ee198896fb8a851ddf69d7c534c968f1b79edd69d"
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
    if OS.mac?
      args << "--with-appletls"
      args << "--without-openssl"
    else
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
