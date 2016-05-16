class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.23.0/aria2-1.23.0.tar.xz"
  sha256 "585185866415bf1120e4bf0a484e7dfec2e9e7c5305023b15ad0f66f90391f93"

  bottle do
    cellar :any_skip_relocation
    sha256 "86774f3165e8d4faf05bf5741141f5f6187668f84d0b1a99491eb2e2ed743813" => :el_capitan
    sha256 "97cbe9e0c08eec1318c3b25ea8b1ae0edd675c60d7c2b6d2cb1e011a4c399834" => :yosemite
    sha256 "13efe8ff0822b98cccce73a84f84588bfe899d11d8272c9d02cc2d6228e7ea9b" => :mavericks
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
