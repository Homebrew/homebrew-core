class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.32.0/aria2-1.32.0.tar.xz"
  sha256 "546e9194a9135d665fce572cb93c88f30fb5601d113bfa19951107ced682dc50"

  bottle do
    cellar :any_skip_relocation
    sha256 "19d139a71749930d7bf15c084035943c1d9980d6e9782392bf24fe0068785ead" => :sierra
    sha256 "fa1343fb305a888ae1b806c7057b50864661b728e89ed1c42288fe0ac837968e" => :el_capitan
    sha256 "804fcc00bd3beab200b77a2e1c538cef4861fb27c97d3fe6ee8d3f67112f57b0" => :yosemite
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
