class Libxmlsec1 < Formula
  desc "XML security library"
  homepage "https://www.aleksey.com/xmlsec/"
  url "https://github.com/lsh123/xmlsec/releases/download/1.3.13/xmlsec1-1.3.13.tar.gz"
  mirror "https://www.aleksey.com/xmlsec/download/xmlsec1-1.3.13.tar.gz"
  sha256 "7e500061eed734c55d74c786998e7562e55b1aaa72a2dff8ce3130b4c5b832d5"
  license "MIT"
  compatibility_version 5

  # Checking the first-party download page persistently fails in the autobump
  # environment, so we check GitHub releases as a workaround.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "291e4edfb032ad38b4990cdf504175c2d5c70dbfacdcf50f03f7804ecf86f444"
    sha256 cellar: :any, arm64_tahoe:       "514ba1e09ca108ffd3fb6f1b08b71960943524e2f086b232e9c4ec0870288e81"
    sha256 cellar: :any, arm64_sequoia:     "d832a71f46f7c8c8e9b63b1cc1620daf30a7993d0fb7475c89251e53b4d168b8"
    sha256 cellar: :any, arm64_linux:       "92ae5b98d8a7c680de56508a76dd02ca8ed457619f500a2029fcaf2f0ac1deca"
    sha256 cellar: :any, x86_64_linux:      "494b438bb6f2fbebe55c6a6e0d76bc3cca381d423f3e2e0714065325a895f8a4"
  end

  depends_on "pkgconf" => :build
  depends_on "gnutls" # Yes, it wants both ssl/tls variations
  depends_on "libxml2"
  depends_on "openssl@4"

  uses_from_macos "libxslt"

  deny_network_access!

  def openssl = deps.map(&:name).find { |d| d.match?(/^openssl(@\d+(\.\d+)*)?$/) }

  def install
    args = %W[
      --disable-apps-crypto-dl
      --disable-crypto-dl
      --disable-mscrypto
      --disable-mscng
      --without-nss
      --without-nspr
      --with-openssl=#{formula_opt_prefix(openssl)}
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"xmlsec1", "--version"
    system bin/"xmlsec1-config", "--version"
  end
end
