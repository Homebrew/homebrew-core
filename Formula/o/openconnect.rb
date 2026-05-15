class Openconnect < Formula
  desc "Open client for Cisco AnyConnect VPN"
  homepage "https://www.infradead.org/openconnect/"
  url "https://www.infradead.org/openconnect/download/openconnect-9.12.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/o/openconnect/openconnect_9.12.orig.tar.gz"
  sha256 "a2bedce3aa4dfe75e36e407e48e8e8bc91d46def5335ac9564fbf91bd4b2413e"
  license "LGPL-2.1-only"
  revision 2

  livecheck do
    url "https://www.infradead.org/openconnect/download.html"
    regex(/href=.*?openconnect[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "02beb4be59b0efe19db016198efb1c0889470de85a7bcc8d456fb9e2d5105897"
    sha256 arm64_sequoia: "9d315e5ff0430cf19b0ad916473773c9244e3d410d1eec526c52664b224ed941"
    sha256 arm64_sonoma:  "e4023b61d9fa5a710c81db230ba7e81e1821c84622a7fff601260383a7931224"
    sha256 sonoma:        "d636ccce3b05b014b8e9020564fafffef66d90fc3fd968e8f6703d884eea2417"
    sha256 arm64_linux:   "f16036645922a933bcaa2eacdc011db910e5a402559fcfc1c1f9b21110fd2b97"
    sha256 x86_64_linux:  "749eb218c2418c7c1223f79be220ca1bde8c43c649f905cea355d36a2dd69a68"
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
    url "https://gitlab.com/openconnect/vpnc-scripts/-/raw/5b9e7e4c8e813cc6d95888e7e1d2992964270ec8/vpnc-script"
    sha256 "dee08feb571dc788018b5d599e4a79177e6acc144d196a776a521ff5496fddb8"
  end

  # Fix for GnuTLS v3.8.1
  # https://gitlab.com/openconnect/openconnect/-/merge_requests/490
  patch do
    url "https://gitlab.com/openconnect/openconnect/-/commit/7512698217c4104aade7a2df669a20de68f3bb8c.diff"
    sha256 "8a26be2116b88bf9ad491b56138498a2a18bd80bb081e90a386ee8817a1314c3"
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

  def post_install
    if (etc/"vpnc/vpnc-script.default").exist?
      opoo <<~EOS
        To avoid destroying any local changes you have made, a newer version of `vpnc-script` has
        been installed as `vpnc-script.default`.
      EOS
    end
  end

  def caveats
    <<~EOS
      A `vpnc-script` has been installed at #{etc}/vpnc/vpnc-script.
    EOS
  end

  test do
    # We need to pipe an empty string to `openconnect` for this test to work.
    assert_match "POST https://localhost/", pipe_output("#{bin}/openconnect localhost 2>&1", "")
  end
end
