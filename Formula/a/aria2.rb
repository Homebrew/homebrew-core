class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.37.0/aria2-1.37.0.tar.xz"
  sha256 "60a420ad7085eb616cb6e2bdf0a7206d68ff3d37fb5a956dc44242eb2f79b66b"
  license "GPL-2.0-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "508d3d5de9d8ba5cdaa3c87f89f39d9080d24f3356f03c552144d9ab0d6e161d"
    sha256 arm64_sequoia: "5869d2fb49078d3c094d30cc47841f64fb5c8e72ce647d7a5d5d1591784f9a3d"
    sha256 arm64_sonoma:  "a128a4ec26ae65668b5ecee5d655148ba9b980525df819ee257c9bcfc70970b3"
    sha256 sonoma:        "675bbd269dc627ae80e5f8c13e002539b0fe60a206b6b4579e3b09dec881f87e"
    sha256 arm64_linux:   "b160d724fe8bc645c8cfcc173efd604442b7774bbb36713f4e4809db3bac3fef"
    sha256 x86_64_linux:  "bb0e79ca14456bd6e4a52f91e0584c5edc96a1cb6c264646f7614f80610ffffa"
  end

  depends_on "pkgconf" => :build
  depends_on "libssh2"
  depends_on "openssl@3"
  depends_on "sqlite"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV.cxx11

    args = %w[
      --disable-silent-rules
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

    system "./configure", *args, *std_configure_args
    system "make", "install"

    bash_completion.install "doc/bash_completion/aria2c"
  end

  test do
    system bin/"aria2c", "https://brew.sh/"
    assert_path_exists testpath/"index.html", "Failed to create index.html!"
  end
end
