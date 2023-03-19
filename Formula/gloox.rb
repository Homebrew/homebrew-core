class Gloox < Formula
  desc "C++ Jabber/XMPP library that handles the low-level protocol"
  homepage "https://camaya.net/gloox/"
  url "https://camaya.net/download/gloox-1.0.26.tar.bz2"
  sha256 "6b45b390d3b0346a3cf6cc118d5ccafcdf10d51be57a02b0076edf064033ab6f"
  license "GPL-3.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/Latest stable version.*?href=.*?gloox[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "46eab221247ef01010c6b159feb6e2f0fc1355c53d1aaa3cbf144c3e5b825f61"
    sha256 cellar: :any,                 arm64_monterey: "5c9ba1c56bf72838684beaf32e452e20bb7e003151e69d7e2beb9ed06d57af3b"
    sha256 cellar: :any,                 arm64_big_sur:  "3a074b66d0c8b73f75842fcb350da30d5c1dfa4babc0f63134d01156c577c3eb"
    sha256 cellar: :any,                 ventura:        "704e1f7fcbfeea920fd04cc51b4e0a986ef51874c352cd66e060ed1fe5b57243"
    sha256 cellar: :any,                 monterey:       "6507e5a77b70a01cfb5d86a7f4ec8bd71755c33bd533b3f726ba293c492155a2"
    sha256 cellar: :any,                 big_sur:        "ff6c2d2cc04577792e75b187f62c6243eeefe6dc715b0d3ebc5d1397dd557861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a520a0278c099ab8d34b6a01354846be465efba2a04e0463c9b7b9baaadb027"
  end

  depends_on "pkg-config" => :build
  depends_on "libidn"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-zlib",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
                          "--without-tests",
                          "--without-examples"
    system "make", "install"
  end

  test do
    system bin/"gloox-config", "--cflags", "--libs", "--version"
  end
end
