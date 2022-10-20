class Opensc < Formula
  desc "Tools and libraries for smart cards"
  homepage "https://github.com/OpenSC/OpenSC/wiki"
  url "https://github.com/OpenSC/OpenSC/releases/download/0.22.0/opensc-0.22.0.tar.gz"
  sha256 "8d4e5347195ebea332be585df61dcc470331c26969e4b0447c851fb0844c7186"
  license "LGPL-2.1-or-later"
  head "https://github.com/OpenSC/OpenSC.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "8d683bfbc7dcaa651ed70ca75333402bc75f47fc2eaf005581138f824db97e52"
    sha256 arm64_big_sur:  "fb1e4fdfdca0bd35600e321fffd758aff4e8557957da8e2a467d4580b5f52092"
    sha256 monterey:       "dfc3fd6cd5a271ed848c471930f5f3f8cdcab1214b0c1eb8090697a9d8e9fc94"
    sha256 big_sur:        "308076bb86f51319361ac05d6abb0d546e021fdef0d85294cce641808dd74d24"
    sha256 catalina:       "78c5529ee73f82e4c4830033a14a24befd358309fe74172e0d3b37b86a5c3e0e"
    sha256 mojave:         "59f94582f376029a1d80d4a1a2dfe0a76efd5ae03c3ae73c620eea10434f43dc"
    sha256 x86_64_linux:   "02841a26a99ee24f685e0ac37b9cec2a905ae85953ae04a59f7e9655c12e87d4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  uses_from_macos "pcsc-lite"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-openssl
      --enable-pcsc
      --enable-sm
      --with-xsl-stylesheetsdir=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl
    ]

    system "./bootstrap"
    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<~EOS
      The OpenSSH PKCS11 smartcard integration will not work from High Sierra
      onwards. If you need this functionality, unlink this formula, then install
      the OpenSC cask.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opensc-tool -i")
  end
end
