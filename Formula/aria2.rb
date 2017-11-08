class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.33.1/aria2-1.33.1.tar.xz"
  sha256 "2539e4844f55a1f1f5c46ad42744335266053a69162e964d9a2d80a362c75e1b"

  bottle do
    cellar :any_skip_relocation
    sha256 "d97e97cf8f8cafceae11083b69911e9067ade8bf9112a4baffc79219580aa790" => :high_sierra
    sha256 "87e3e594eebbf6820cb1af881a570cceee6fd8621c883033208fc970a4bc52fa" => :sierra
    sha256 "dce6d7d93b447edbfbc47d5a5d5ea69129015de3a504f2cb20b78e91d5117ec1" => :el_capitan
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
    assert_predicate testpath/"index.html", :exist?, "Failed to create index.html!"
  end
end
