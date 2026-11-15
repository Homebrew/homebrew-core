class Opensc < Formula
  desc "Tools and libraries for smart cards"
  homepage "https://github.com/OpenSC/OpenSC/wiki"
  license "LGPL-2.1-or-later"

  stable do
    url "https://github.com/OpenSC/OpenSC/releases/download/0.27.1/opensc-0.27.1.tar.gz"
    sha256 "976f4a23eaf3397a1a2c3a7aac80bf971a8c3d829c9a79f06145bfaeeae5eca7"

    # Backport support for OpenSSL 4.0
    patch do
      url "https://github.com/OpenSC/OpenSC/commit/8ad96adc5fea0cef923a2a679600f3a5c4c5bfce.patch?full_index=1"
      sha256 "0b4c4985150892ce1a0108b1a36f3db4c29e7f4453e86b039bf3b36384db43ee"
      type :backport
      resolves "https://github.com/OpenSC/OpenSC/pull/3655"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "e461bcb7d55a07718b3c30b27d5dffd6ad9854fe8934145f046bd8d12b22f55e"
    sha256 arm64_tahoe:       "89c9f2fb19add21311025692b85e8e5e9b8b47a715f41046745f146f16b8de51"
    sha256 arm64_sequoia:     "7cfe160130e306d3e502ee373b41d6d4f8550030ff1ae24a4ba3da611c09eb2a"
    sha256 arm64_linux:       "79bee22657f8edb9b348b8a2e51ab94fc1e54bbd919c9c739185353f6373d794"
    sha256 x86_64_linux:      "1649fd1a59be34d6b3640cf7b57bfb7c00c058e82ec3e188dd148a451989c3a7"
  end

  head do
    url "https://github.com/OpenSC/OpenSC.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "docbook-xsl" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "pcsc-lite"

  on_linux do
    depends_on "glib"
    depends_on "readline"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    args = %W[
      --disable-silent-rules
      --enable-openssl
      --enable-pcsc
      --enable-sm
      --with-xsl-stylesheetsdir=#{formula_opt_prefix("docbook-xsl")}/docbook-xsl
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
