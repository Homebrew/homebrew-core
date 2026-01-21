class Owfs < Formula
  desc "Monitor and control physical environment using Dallas/Maxim 1-wire system"
  homepage "https://owfs.org/"
  url "https://github.com/owfs/owfs/releases/download/v3.2p4/owfs-3.2p4.tar.gz"
  version "3.2p4"
  sha256 "af0a5035f3f3df876ca15aea13486bfed6b3ef5409dee016db0be67755c35fcc"
  license "GPL-2.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "cfce021f58090c3ca7128b8cd83544f67ee1305486f639e0659f799381b2c0ea"
    sha256 cellar: :any,                 arm64_sequoia:  "9ffbd0a7e7138e0e41418388b894e28c1afa188d2182acd3f8518dfad76fd4a0"
    sha256 cellar: :any,                 arm64_sonoma:   "1366e03d70c70d75caede1b7144164ed21adf1396793cb0f75ce9cf3a7d6b1bc"
    sha256 cellar: :any,                 arm64_ventura:  "2c892df4127820daca0fbfd2a6ef3be23d85173ed4a67b04d5bd9501cc2c215a"
    sha256 cellar: :any,                 arm64_monterey: "60b2cdf16ab634a941884f3053afade439202e030b20defb61371ff4bd666a50"
    sha256 cellar: :any,                 arm64_big_sur:  "62b0c429498ff8aef96aa05ec7e4502978b3d98aa289ff8283a27de41352b68a"
    sha256 cellar: :any,                 sonoma:         "6ac085fdb22ab9cf973aa439322c83ec6ec01073fe70d2af0e3d9ff42f784c8b"
    sha256 cellar: :any,                 ventura:        "ced3c8b0ea60f52938ff78d7b9362b3d501b5c593a54014b4ef8bc3a8fa22283"
    sha256 cellar: :any,                 monterey:       "578554d18620a943b499b22046d97c9fc818ad1ebad6552484a4dec245c7ce0e"
    sha256 cellar: :any,                 big_sur:        "d1f522c35882921728f0bc27c62c0b3a9c225278729ecf3b30ea093c21a1cc4b"
    sha256 cellar: :any,                 catalina:       "659e132d059f5b07c1f53f7ebc8676edf732da7b36f4e85065a30fe616358f50"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f84aad3b6008729382761e7b772b106b7db195baa4515f99b87810cad4652101"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc7081d7fe26ec46288fa5bb16f5404e9697f1c567dde4ded5e181f0b54bbb6b"
  end

  depends_on "pkgconf" => :build
  depends_on "libftdi"
  depends_on "libusb"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE" if OS.mac? && MacOS.version >= :sequoia

    system "./configure", "--disable-swig",
                          "--disable-owtcl",
                          "--disable-zero",
                          "--disable-owpython",
                          "--disable-owperl",
                          "--disable-swig",
                          "--enable-ftdi",
                          "--enable-usb",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"owserver", "--version"
  end
end
