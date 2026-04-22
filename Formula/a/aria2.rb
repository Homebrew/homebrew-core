class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.37.0/aria2-1.37.0.tar.xz"
  sha256 "60a420ad7085eb616cb6e2bdf0a7206d68ff3d37fb5a956dc44242eb2f79b66b"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    sha256 arm64_tahoe:   "e02198308a07cc13589297bd682c0f63fe2e4ce09ff61d373696f4157eab89e5"
    sha256 arm64_sequoia: "b8312eb29cb3a058600a38b560efcb7e2b4ae951de0010e64abfd9194f07392c"
    sha256 arm64_sonoma:  "8815b6b79395235863349628dc0d753bbee9069e99d94257b7646ffd85615623"
    sha256 sonoma:        "b88e53b1c54d82af91dea90551fc114b7c02149972d536b9d55a33b12f9a9fd5"
    sha256 arm64_linux:   "151095fbbfe8819535eb1f3dc63642103f793b79ead0ab8282381baebaad0485"
    sha256 x86_64_linux:  "f2a416d17d88fdbc5a4dabd1a6520eb736964c6d21cd7a9e2b2591330d74bdf5"
  end

  depends_on "pkgconf" => :build
  depends_on "c-ares"
  depends_on "libssh2"
  depends_on "openssl@3"
  depends_on "sqlite"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.cxx11
    ENV.append "LIBS", "-framework Security" if OS.mac?

    args = %w[
      --disable-silent-rules
      --with-libssh2
      --without-gnutls
      --without-libgmp
      --without-libnettle
      --without-libgcrypt
      --without-appletls
      --with-openssl
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"

    bash_completion.install "doc/bash_completion/aria2c"
  end

  test do
    system bin/"aria2c", "https://brew.sh/"
    assert_path_exists testpath/"index.html", "Failed to create index.html!"
  end
end
