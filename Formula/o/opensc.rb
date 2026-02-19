class Opensc < Formula
  desc "Tools and libraries for smart cards"
  homepage "https://github.com/OpenSC/OpenSC/wiki"
  url "https://github.com/OpenSC/OpenSC/releases/download/0.26.1/opensc-0.26.1.tar.gz"
  sha256 "f16291a031d86e570394762e9f35eaf2fcbc2337a49910f3feae42d54e1688cb"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "96eafdcef6376fa91178d0a442131ac4d8859edec6aefe130ccced5f3b8ea147"
    sha256 arm64_sequoia: "582d60eab77edf304ebac576d8513f885bd0ccef27ea7c9f5c4eeb35bb6871f4"
    sha256 arm64_sonoma:  "e019f55b30b4816f13dbe4a38bb711bda41117796a11d20c451498e6e291690a"
    sha256 sonoma:        "7fba702bde073f6006fc7c108d6f72dd51898c2e3e7c40dc48606e88cfec13aa"
    sha256 arm64_linux:   "17611acadab74a5131577374a5428856b1885c903e2c174f22622ce4dcac6f80"
    sha256 x86_64_linux:  "aa839dfd0de004bc95bbc41534ad751936c657931b343e7aad89f2a79ca14d02"
  end

  head do
    url "https://github.com/OpenSC/OpenSC.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "docbook-xsl" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "pcsc-lite"

  on_linux do
    depends_on "glib"
    depends_on "readline"
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      --disable-silent-rules
      --enable-openssl
      --enable-pcsc
      --enable-sm
      --with-xsl-stylesheetsdir=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl
    ]

    system "./bootstrap" if build.head?
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  def caveats
    on_macos do
      <<~EOS
        The OpenSSH PKCS11 smartcard integration will not work.
        If you need this functionality, unlink this formula, then install
        the OpenSC cask.
      EOS
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opensc-tool -i")
  end
end
