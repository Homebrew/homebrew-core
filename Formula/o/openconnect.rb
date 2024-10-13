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

  bottle do
    rebuild 2
    sha256 arm64_sequoia:  "76a21b129bbc6a7dbcd67f88f4b2e2a0ca6cb3d5188b7ba763ef669013b58b7c"
    sha256 arm64_sonoma:   "a6594e9c2ba4bfa4f235839a9f504f354e82722ae1a2f6e7f3d9a17727ece429"
    sha256 arm64_ventura:  "c1f6c601ae384e7ccb83c875c762ab73134dac41ce77a8cfc0fd41d166dda58a"
    sha256 arm64_monterey: "63304d1ce4715c73c59abd0777fc34f1f77e413c4ce4d1933d78b629abb7d95e"
    sha256 sonoma:         "330f76952b9e047eaab8fbc0e55378e600367504cded0c4c2879630559a0f6eb"
    sha256 ventura:        "c6b26f039f0ad3f5ce853111ebb62556885c48fba36cd63f48353f8dd8a12287"
    sha256 monterey:       "236d104feadaa7f99b8c10fef77adf469fa7499ffd55de499db04da7fd47a710"
    sha256 x86_64_linux:   "35d66b532fb2760b5265d32eca18f98fb8a938edcef09498fe6126e81c9fd085"
  end

  head do
    url "git://git.infradead.org/users/dwmw2/openconnect.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gettext" => :build # for msgfmt
  depends_on "pkg-config" => :build

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

    system "./configure", *args, *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  def caveats
    s = <<~EOS
      A `vpnc-script` has been installed at #{etc}/vpnc/vpnc-script.
    EOS

    s += if (etc/"vpnc/vpnc-script.default").exist?
      <<~EOS

        To avoid destroying any local changes you have made, a newer version of this script has
        been installed as `vpnc-script.default`.
      EOS
    end.to_s

    s
  end

  test do
    # We need to pipe an empty string to `openconnect` for this test to work.
    assert_match "POST https://localhost/", pipe_output("#{bin}/openconnect localhost 2>&1", "")
  end
end
