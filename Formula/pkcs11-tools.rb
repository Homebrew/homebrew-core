class Pkcs11Tools < Formula
  desc "Tools to manage objects on PKCS#11 crypotographic tokens"
  homepage "https://github.com/Mastercard/pkcs11-tools"
  url "https://github.com/Mastercard/pkcs11-tools/releases/download/v2.5.0/pkcs11-tools-2.5.0.tar.gz"
  sha256 "4e2933ba19eef64a4448dfee194083a1db1db5842cd043edb93bbf0a62a63970"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "0745f7e6f38190263957a3e110eba0e1019824a8e45f80a97b486b09ae976ebd"
    sha256 cellar: :any,                 arm64_monterey: "81f2281b90d03c95730ca77ab40be136a2d4d4536b4b548dc19c53050353419c"
    sha256 cellar: :any,                 arm64_big_sur:  "f8890ce23a1b904f23242b226ba11b646aa09e33550f2da22abc27b258d42a7c"
    sha256 cellar: :any,                 ventura:        "fbf21d6143981827d9ee88fcaf4d6d0d8090c20fcb04716a3e70255dedbdc90b"
    sha256 cellar: :any,                 monterey:       "ab0728b88903cab23dff9a9cb8220649dffe62386435b12682c8b5ab53def285"
    sha256 cellar: :any,                 big_sur:        "9894a2f01f24d23cc1403f81ebf6b0c8e3497da5064116b8c9710b4ee889bc93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14db1a21d1813e2583e49c0700c3e8384b943fa5b341c1b7a98752752de88e5c"
  end

  depends_on "pkg-config" => :build
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
    end
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    # configure new softhsm token, generate a token key, and use it
    mkdir testpath/"tokens"
    softhsm_conf = testpath/"softhsm.conf"

    softhsm_conf.write <<~EOS
      directories.tokendir = #{testpath}/tokens
      directories.backend = file
      log.level = INFO
      slots.removable = false
      slots.mechanisms = ALL
      library.reset_on_fork = false
    EOS

    ENV["SOFTHSM2_CONF"] = softhsm_conf
    ENV["PKCS11LIB"] = Formula["softhsm"].lib/"softhsm/libsofthsm2.so"
    ENV["PKCS11TOKENLABEL"] = "test"
    ENV["PKCS11PASSWORD"] = "0000"

    system "softhsm2-util", "--init-token", "--slot", "0", "--label", "test", "--pin", "0000", "--so-pin", "0000"
    system "p11keygen", "-i", "test", "-k", "aes", "-b", "128", "encrypt"
    system "p11kcv", "seck/test"
    system "p11ls"
  end
end
