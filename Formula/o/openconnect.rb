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
    rebuild 1
    sha256 arm64_sonoma:   "9d866635b379a1657a60581d2de060c2521cb0949b37de5d7390efbf6148e4db"
    sha256 arm64_ventura:  "ad530a711e9dd67b9f57c6be4bf6329ad15b81fe0f9ac068ad158d92c59a1039"
    sha256 arm64_monterey: "732c9c632480ca2bf48cf1235bbc381b710a4973b02b935b5ae2937e56c2ee87"
    sha256 sonoma:         "7116a890b91af980f559b80db6ec2a728053d7b1f8de7b30001622bc10caf536"
    sha256 ventura:        "2686a07bce4e89465c0c4e4adedb2cffe3672216cf248213741e2ab853ce1e3d"
    sha256 monterey:       "ad97ba79e7db7a465c49504d7f9bd87db6d63e09e6c761475589ab3273c1c292"
    sha256 x86_64_linux:   "e71c4302f659b47151247aa77eab2c7c9e4ce181e3e84e480a4bdda42c920009"
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
