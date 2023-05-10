class Pkcs11Tools < Formula
  desc "Tools to manage objects on PKCS#11 crypotographic tokens"
  homepage "https://github.com/Mastercard/pkcs11-tools"
  url "https://github.com/Mastercard/pkcs11-tools/releases/download/v2.5.1/pkcs11-tools-2.5.1.tar.gz"
  sha256 "d7d30438cbdaeae208040b3f04c8f984cfb6af43b69b53206c6c23a2b6c0d29f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b71254c54ea4890b0c691b05be545227350a59ee679a115bfbe0859c4295782c"
    sha256 cellar: :any,                 arm64_monterey: "65105e177195b12190544277d9b4e1ed7e19abde77f3168b7df8926184809eda"
    sha256 cellar: :any,                 arm64_big_sur:  "64b9fdd8ef72d54bbfb856eed8444a3b590f7e7a350aa326ab7e962eccbd916c"
    sha256 cellar: :any,                 ventura:        "5d70386c6097b1ff5ef952a03b351957a5978c63b28635ff48ce55091049f743"
    sha256 cellar: :any,                 monterey:       "37e702aaa2e30c62f1a3c9f3e2ad40a555b47f63032418824fab51e21ff3f817"
    sha256 cellar: :any,                 big_sur:        "a9a7df48c8a96c6e270f2e4598a0a454b9a592a2f97cd109597639028d3dda00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70ea2cf8efd46b5673a204aabc8aa5f2780082df120f2b78289fd7127e48c251"
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
    system "#{bin}/p11keygen", "-i", "test", "-k", "aes", "-b", "128", "encrypt"
    system "#{bin}/p11kcv", "seck/test"
    system "#{bin}/p11ls"
  end
end
