class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.36.0/aria2-1.36.0.tar.xz"
  sha256 "58d1e7608c12404f0229a3d9a4953d0d00c18040504498b483305bcb3de907a5"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 arm64_ventura:  "cb572370ae31983f3cb7933f52ac2011c4f2f41858106c9abd1b22c83ba3114a"
    sha256 arm64_monterey: "b0ec32121f2f4c94afce1cf43101d0441176e4d3de2461160cf220b4c4c2a89f"
    sha256 arm64_big_sur:  "89db8d96ab739c0ebcc8a800169d7001c18fae4d3fce8217b8ffa5455d1f46cf"
    sha256 ventura:        "90e6ffc911cf05a056a6a19ac4169cba8f315c6d740ee02892ecb57cbab74ba8"
    sha256 monterey:       "410b790649fe92ac3c146aa394a6ff1d70411303e68b7c4ff5c5e4ce82435b30"
    sha256 big_sur:        "cebab5dd720d1b80d429c50b7e84944912a2e2c25f471d6f379fbb5670080026"
    sha256 catalina:       "2be60bad723be29d33143d487e6bc0c32e0a37de083043bb2fa5c31e586ad37e"
    sha256 x86_64_linux:   "04dc2fd6656aae3435205cb9c8e4c43c902d02a2e639e61c100c0125e19f62e2"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libssh2"
  depends_on "sqlite"

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
