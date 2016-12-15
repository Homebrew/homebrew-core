class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.30.0/aria2-1.30.0.tar.xz"
  sha256 "bf6c5366d11d2a6038c8e19f01f9b874041793aaf317e0206120e3e8c9c431f6"

  bottle do
    cellar :any_skip_relocation
    sha256 "26d71f773b33bbf27582645acc2dcf62b807afb173e45ade18e6b5e252a829ad" => :sierra
    sha256 "1dd0761de5297ada97baa1f822649438cee9fc5b22582925fcde54cb49aff249" => :el_capitan
    sha256 "060dde648482c6f9dfb68bebfb8fb627c5c77197543ec913e2b70cc3a94f545c" => :yosemite
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
