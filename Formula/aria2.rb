class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.26.0/aria2-1.26.0.tar.xz"
  sha256 "c828f3375e9ab251239747fbbbf747e5027339080b9fdec29ac746a0b8c6088d"

  bottle do
    cellar :any_skip_relocation
    sha256 "071afab66c63b761866e35eb957494e316708c9e3c32df06783de7b0d05030f7" => :el_capitan
    sha256 "fa67f7c27ae72e567bd8d6d032d88cfbc9c2dc6b759a1b0877844b171627b115" => :yosemite
    sha256 "d0dfc88e1e05d2d2aa3eb86b88572c09b6632021c737f40f6f10d4f976e8863f" => :mavericks
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
