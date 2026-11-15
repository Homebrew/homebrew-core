class Gloox < Formula
  desc "C++ Jabber/XMPP library that handles the low-level protocol"
  homepage "https://camaya.net/gloox/"
  url "https://camaya.net/download/gloox-1.0.28.tar.bz2"
  sha256 "591bd12c249ede0b50a1ef6b99ac0de8ef9c1ba4fd2e186f97a740215cc5966c"
  license "GPL-3.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/Latest stable version.*?href=.*?gloox[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "15e119b4db6baadcc2c1e77bc4826c9b0921bc22b12e08032b3a76726d6dc37d"
    sha256 cellar: :any, arm64_tahoe:       "304e8bffdea49fdf5962fac2f0d4e9edeab843b7627999d3b188bf13b069eadf"
    sha256 cellar: :any, arm64_sequoia:     "afa88750e0693f66261b38412a1aa3e7610d73b44800303993d089284424d83e"
    sha256 cellar: :any, arm64_linux:       "818676a89babfd1d09dd9481756e5bf52bd6ea28c13877df2edbadd3cdcc01bd"
    sha256 cellar: :any, x86_64_linux:      "ac52d874b948555015ff490fdcc44a27b689d573193af7d50e7f34cb8925a34d"
  end

  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "libidn"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    system "./configure", "--disable-silent-rules",
                          "--with-zlib",
                          "--without-tests",
                          "--without-examples",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"gloox-config", "--cflags", "--libs", "--version"
  end
end
