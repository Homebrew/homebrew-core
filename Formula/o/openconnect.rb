class Openconnect < Formula
  desc "Open client for Cisco AnyConnect VPN"
  homepage "https://www.infradead.org/openconnect/"
  url "https://www.infradead.org/openconnect/download/openconnect-9.21.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/o/openconnect/openconnect_9.21.orig.tar.gz"
  sha256 "5b32369467db6e5f317aa1ed12cfcbb81ed00bdbc765450b6bfcbdc300944a58"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.infradead.org/openconnect/download.html"
    regex(/href=.*?openconnect[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "f409aa8b1c88ff33f1b5ce49740814bb932dba4a3877bc6a124a0f16fd39bf9e"
    sha256 arm64_sequoia: "e435e4d4b91995be58f866b8012adda7dcb7cfbdff02fa7abcbf017f0b389fc3"
    sha256 arm64_sonoma:  "cc157cf32a317f138140feb5f2fa948135f504805ba5f16a28ac610806fe67b2"
    sha256 sonoma:        "002d07d8c2aa42c02b8e9fa269b74fbccf0f1c0e1389da06f52e61c8309f4d45"
    sha256 arm64_linux:   "3296f51486c2af4ac2f005cd309b5aa471594c3c18a8646117932b1d21f205fd"
    sha256 x86_64_linux:  "34be5e6c7b3bec8f0ee6514998a588745a0cd1cbcec6596699c28aecb256a4fd"
  end

  head do
    url "git://git.infradead.org/users/dwmw2/openconnect.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gettext" => :build # for msgfmt
  depends_on "pkgconf" => :build

  depends_on "gmp"
  depends_on "gnutls"
  depends_on "nettle"
  depends_on "p11-kit"
  depends_on "stoken"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "vpnc-script" do
    url "https://gitlab.com/openconnect/vpnc-scripts/-/raw/ce9e961bd0f6b867e1c7c35f78f6fb973f6ff101/vpnc-script"
    sha256 "f0c4d936a382f07711263242699b5e2d85d1ace37136bb78785d352997c17742"
  end

  def install
    (etc/"vpnc").install resource("vpnc-script")
    chmod 0755, etc/"vpnc/vpnc-script"

    if build.head?
      ENV["LIBTOOLIZE"] = "glibtoolize"
      system "./autogen.sh"
    end

    args = %W[
      --sbindir=#{bin}
      --localstatedir=#{var}
      --with-vpnc-script=#{etc}/vpnc/vpnc-script
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  def caveats
    <<~EOS
      A `vpnc-script` has been installed at #{etc}/vpnc/vpnc-script.
      If you applied any local changes then newer versions will be
      available at #{etc}/vpnc/vpnc-script.default
    EOS
  end

  test do
    # We need to pipe an empty string to `openconnect` for this test to work.
    assert_match "POST https://localhost/", pipe_output("#{bin}/openconnect localhost 2>&1", "")
  end
end
