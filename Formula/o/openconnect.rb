class Openconnect < Formula
  desc "Open client for Cisco AnyConnect VPN"
  homepage "https://www.infradead.org/openconnect/"
  url "https://www.infradead.org/openconnect/download/openconnect-9.12.tar.gz"
  sha256 "a2bedce3aa4dfe75e36e407e48e8e8bc91d46def5335ac9564fbf91bd4b2413e"
  license "LGPL-2.1-only"
  revision 1

  livecheck do
    url "https://www.infradead.org/openconnect/download.html"
    regex(/href=.*?openconnect[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "bacd0a4fde84646627d45b4b821956d89442cd67e3645d6b6acb78957f96e01f"
    sha256 arm64_sequoia: "8cf6e196c261898329d0bcf1ef0a0f6ea239c12f0884377e240262655464d85b"
    sha256 arm64_sonoma:  "1612de7a532555d862636d428aaee7bb2042ed62adade421425f93fb64f5ffdf"
    sha256 sonoma:        "8ddfafaffa683afac65283d1cb7386916d6dd81cf1bd35f04e51572ca5e2ce37"
    sha256 arm64_linux:   "2525fee7be139490f52d7426415ac2bc8fcc916737bdddbeb464295314167429"
    sha256 x86_64_linux:  "8a12c919696a92c83d8da6ac36c3965e70ad500810db4322e0abd72ab7bd9a4f"
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
