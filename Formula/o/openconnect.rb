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
    sha256 arm64_ventura:  "5046fefc55cc7812e1ffce03f00ff5bd3e8c08f1a743a8af59f5ab9965950806"
    sha256 arm64_monterey: "b177be2f871aedf5f464ce3ad013de36c8873cf896447619a43b62ae9a8e8fed"
    sha256 arm64_big_sur:  "c35595ec111e4ca4decf99647017b9461531b3b8f70ab804bae311501ca6c39b"
    sha256 ventura:        "f8c9b328f46d39e50839fa24f7997244da7deaf2925d1a5f1f3002a88ca57bb9"
    sha256 monterey:       "984e1c2b131997ad2800fb5a2a184f2b6fe08ed40c939ada2ab70c3d880b49f2"
    sha256 big_sur:        "1148d11c813378bb5b754c111564ccbf948e624a6925941e54626ea63852a0fd"
    sha256 x86_64_linux:   "ba03e1ce32924cb034c77db27bb464661769072e31216b9d2224daf84270a394"
  end

  head do
    url "git://git.infradead.org/users/dwmw2/openconnect.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "stoken"

  resource "vpnc-script" do
    url "https://gitlab.com/openconnect/vpnc-scripts/-/raw/473d3e810b8fe8223058ab580fac20c53204e677/vpnc-script"
    sha256 "4e0d4367806c8b54da76aaae4bb550993d8155894006705d21b16eabdbf47559"
  end

  def install
    (etc/"vpnc").install resource("vpnc-script")
    chmod 0755, etc/"vpnc/vpnc-script"

    if build.head?
      ENV["LIBTOOLIZE"] = "glibtoolize"
      system "./autogen.sh"
    end

    args = %W[
      --prefix=#{prefix}
      --sbindir=#{bin}
      --localstatedir=#{var}
      --with-vpnc-script=#{etc}/vpnc/vpnc-script
    ]

    system "./configure", *args
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
