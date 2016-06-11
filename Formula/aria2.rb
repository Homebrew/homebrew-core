class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.23.0/aria2-1.23.0.tar.xz"
  sha256 "585185866415bf1120e4bf0a484e7dfec2e9e7c5305023b15ad0f66f90391f93"

  bottle do
    cellar :any_skip_relocation
    sha256 "2414af6389422db8587a4dd286a99168407024e35a7871ce5ba3a1bb06aee950" => :el_capitan
    sha256 "97b2e9cc807535b2b9776924cf7278bce30f5c4e06c02047a2d98dd6538dd95c" => :yosemite
    sha256 "765d2ec7e4f597f3f022235f96d67b0ce714b727af79a0b8a085ec0cca042567" => :mavericks
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
