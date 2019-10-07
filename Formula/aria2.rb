class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.35.0/aria2-1.35.0.tar.xz"
  sha256 "1e2b7fd08d6af228856e51c07173cfcf987528f1ac97e04c5af4a47642617dfd"

  bottle do
    cellar :any
    sha256 "084fcbf9696f9dc24fb6f86d0082d4338895b2b65a577a7fafe093d746063290" => :catalina
    sha256 "a5244c4733c43fdd2441e97abe12211cc718a383d5e7c3be2117cec7d87f9424" => :mojave
    sha256 "8fe4633e41f67b4a80ad80f6c3423641d39e091779636c7b62e046c50331fe87" => :high_sierra
    sha256 "04b6207d99d9882c41f11178a70f61c5aebc43e9db0d8ea87c2d870de2f7c646" => :sierra
    sha256 "82f36d7a6cb88b292430a5ea05389e6e066f7e059df2468a2639cdd7844988c4" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libssh2"

  def install
    ENV.cxx11

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-appletls
      --with-libssh2
      --without-openssl
      --without-gnutls
      --without-libgmp
      --without-libnettle
      --without-libgcrypt
    ]

    system "./configure", *args
    system "make", "install"

    bash_completion.install "doc/bash_completion/aria2c"
  end

  test do
    system "#{bin}/aria2c", "https://brew.sh/"
    assert_predicate testpath/"index.html", :exist?, "Failed to create index.html!"
  end
end
