class Pkcs11Tools < Formula
  desc "Tools to manage objects on PKCS#11 crypotographic tokens"
  homepage "https://github.com/Mastercard/pkcs11-tools"
  url "https://github.com/Mastercard/pkcs11-tools/releases/download/v3.0.0/pkcs11-tools-3.0.0.tar.gz"
  sha256 "da87f7371be0c94e6ae11cb65c033fbdc9be5549430b7c6f7a90abca200dcfcf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c226d97ae6a863b54da9102b0e957528b0916d7c5301928d0be68589cbcf8d80"
    sha256 cellar: :any, arm64_sequoia: "e9c6808bf746910582e3d676f0c2e7df3fcbe9a0735eb68c546dc001c59876c0"
    sha256 cellar: :any, arm64_sonoma:  "d1aa10759d83a4c6a9cdb66a2619a9b0a53dce443c4a9daad5971e5283df0356"
    sha256 cellar: :any, sonoma:        "1e633c9727fdb43fc0096ef9d9ec96af9cc4b2ff50258d2d204ec0ce1e36193a"
    sha256 cellar: :any, arm64_linux:   "152142a9362cad79d82dddbe8a58eea70980306428735d230dc86ce4c8d89861"
    sha256 cellar: :any, x86_64_linux:  "9f508ab8f95eb06dcc84950bae1b5c2901a48014a606e0b250ac236b34328b10"
  end

  depends_on "pkgconf" => :build
  depends_on "softhsm" => :test
  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  # Add `x` permissions to `with_pkcs11_common` script
  patch do
    url "https://github.com/Mastercard/pkcs11-tools/commit/13154703de39827c791c8e11e1a43e23edec2894.patch?full_index=1"
    sha256 "4e5fd88dc06c6376c1ced8ddd60346368b2723a062920189d082ac61a4ce45ce"
    type :backport
    resolves "https://github.com/Mastercard/pkcs11-tools/issues/85"
  end

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
