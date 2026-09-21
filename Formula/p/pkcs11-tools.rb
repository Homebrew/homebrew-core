class Pkcs11Tools < Formula
  desc "Tools to manage objects on PKCS#11 crypotographic tokens"
  homepage "https://github.com/Mastercard/pkcs11-tools"
  url "https://github.com/Mastercard/pkcs11-tools/releases/download/v3.1.0/pkcs11-tools-3.1.0.tar.gz"
  sha256 "ef6d07b5527214cf8dcbed4f017569146f74dd6eb6aa9d5e7297418299b7947d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9a25cf895785bd56430b810a55905e175228cbc2844807c78654c4dda218b9fa"
    sha256 cellar: :any, arm64_tahoe:       "5b02e59c3f8c22113c8b018ff174c8161114bb71d6fda388d15a5909742f4b27"
    sha256 cellar: :any, arm64_sequoia:     "9d27731ea76ada1931c7640bdd28941d96be8b3530606ddd2fdd75a6f38c8e67"
    sha256 cellar: :any, arm64_sonoma:      "dadb18faf7a87e2533761708ba4544c0f5888827e1c7825beb7e4e29db500baf"
    sha256 cellar: :any, sonoma:            "29de8f4a0e24abc961812265ca1d38fcf80492b6852bc2370a655311c00e7ef3"
    sha256 cellar: :any, arm64_linux:       "1bdf74894a71fb209115f44c7d31d3f6b764d7c9253a9a093a302867645e0a97"
    sha256 cellar: :any, x86_64_linux:      "21fd610270f0466e7874a83f473ce0f0c3f37f8a182366e2b37457f81c4f8978"
  end

  depends_on "pkgconf" => :build
  depends_on "softhsm" => :test
  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  # Fix Linux build error using gnulib upstream commit.
  # ../gl/string.h:965:1: error: expected ',' or ';' before '_GL_ATTRIBUTE_MALLOC'
  # Remove when the gnulib submodule is updated and available in a release
  patch :p2 do
    on_linux do
      url "https://git.savannah.gnu.org/cgit/gnulib.git/patch/lib?id=cc91160a1ea5e18fcb2ccadb32e857d365581f53"
      directory "gl"
      type :backport
      resolves "https://github.com/Mastercard/pkcs11-tools/issues/37"
    end
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    # configure new softhsm token, generate a token key, and use it
    mkdir testpath/"tokens"
    softhsm_conf = testpath/"softhsm.conf"

    softhsm_conf.write <<~CONF
      directories.tokendir = #{testpath}/tokens
      directories.backend = file
      log.level = INFO
      slots.removable = false
      slots.mechanisms = ALL
      library.reset_on_fork = false
    CONF

    ENV["SOFTHSM2_CONF"] = softhsm_conf
    ENV["PKCS11LIB"] = Formula["softhsm"].lib/"softhsm/libsofthsm2.so"
    ENV["PKCS11TOKENLABEL"] = "test"
    ENV["PKCS11PASSWORD"] = "0000"

    system "softhsm2-util", "--init-token", "--slot", "0", "--label", "test", "--pin", "0000", "--so-pin", "0000"
    system bin/"p11keygen", "-i", "test", "-k", "aes", "-b", "128", "encrypt"
    system bin/"p11kcv", "seck/test"
    system bin/"p11ls"
  end
end
