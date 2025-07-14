class Openconnect < Formula
  desc "Open client for Cisco AnyConnect VPN"
  homepage "https://www.infradead.org/openconnect/"
  url "https://www.infradead.org/openconnect/download/openconnect-9.12.tar.gz"
  sha256 "a2bedce3aa4dfe75e36e407e48e8e8bc91d46def5335ac9564fbf91bd4b2413e"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.infradead.org/openconnect/download.html"
    regex(/href=.*?openconnect[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 arm64_sequoia: "5f8451259fc62b9d9137d92ef27cb8674d429b06e4a3e2d30bd7352131126b24"
    sha256 arm64_sonoma:  "90a8abdf95806d378499c11c363e93ff20724d02d8366d3a0f3ad9c1484281a3"
    sha256 arm64_ventura: "2c25aee8a4b6d654d03f3f66d3a2ef14193c1d4bf1c5be5a7ac8de1a39030411"
    sha256 sonoma:        "30ba2ca9744e4083be325a54aa62bbcb63044ffbfb1d1b22bfa1a6e4f7425e97"
    sha256 ventura:       "a4b0f68f401974f354e8116066306fb6c39932024911a4a64d524894ac387633"
    sha256 arm64_linux:   "02d74cdcd601f029c380d447f55b807ea503c88133484edca2a9757fc8d052c0"
    sha256 x86_64_linux:  "04741ae1bce5f7c984ddb98c787972f7186cb6b9d366e7e6ee743ea65927cafa"
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
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
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
