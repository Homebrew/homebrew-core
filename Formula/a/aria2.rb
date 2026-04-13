class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.37.0/aria2-1.37.0.tar.xz"
  sha256 "60a420ad7085eb616cb6e2bdf0a7206d68ff3d37fb5a956dc44242eb2f79b66b"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "8253bf83d39fcdb91b7a251b2d38f0e32f21a0352f2e3798f5a376ba21ae68e9"
    sha256 arm64_sequoia: "c7a6244ec33cb6eaf959d61616b90b08e331ae172936052709f4b2934d36dcb9"
    sha256 arm64_sonoma:  "5822684ab206b076690a5b3b53331a4e351440a45fe6e649e3e64f6a088f2e17"
    sha256 sonoma:        "08007898a6dc4b162547081eb85329457345688279d6dce42f98d601e19ad799"
    sha256 arm64_linux:   "4d5aac6c6905b3274f33b2160bf446293785eebc547c2d398562eb5acf576d7f"
    sha256 x86_64_linux:  "ce15dc949ff077b3ded7d07bb45964a17a44a603e97a6be66ead70e9682f1d96"
  end

  depends_on "pkgconf" => :build
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
