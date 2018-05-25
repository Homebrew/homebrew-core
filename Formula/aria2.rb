class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.34.0/aria2-1.34.0.tar.xz"
  sha256 "3a44a802631606e138a9e172a3e9f5bcbaac43ce2895c1d8e2b46f30487e77a3"

  bottle do
    cellar :any_skip_relocation
    sha256 "b31c015ecbdd51db5f0287106c543d59f2505bc3aa221a3bbfbfddd3cbf2f8fc" => :high_sierra
    sha256 "51d336692462ed3b530ce1059bab4cdc4119da6be59c55cf344a70a826bd1812" => :sierra
    sha256 "71ff909a076d91fae49857f2d9c20d2e1c06e099c755648ef9dd5611ef64441e" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libssh2" => :optional

  needs :cxx14

  def install
    # Fix "error: use of undeclared identifier 'make_unique'"
    # Reported upstream 15 May 2018 https://github.com/aria2/aria2/issues/1198
    inreplace "src/bignum.h", "make_unique", "std::make_unique"
    inreplace "configure", "-std=c++11", "-std=c++14"

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
