class Pkcs11Tools < Formula
  desc "Tools to manage objects on PKCS#11 crypotographic tokens"
  homepage "https://github.com/Mastercard/pkcs11-tools"
  url "https://github.com/Mastercard/pkcs11-tools/releases/download/v2.5.0/pkcs11-tools-2.5.0.tar.gz"
  sha256 "4e2933ba19eef64a4448dfee194083a1db1db5842cd043edb93bbf0a62a63970"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1d986581dbe9eb9490e77d3e61d5ce90ee30d6777f1cd2cb9fe0d39d0b70c2f8"
    sha256 cellar: :any,                 arm64_monterey: "bf484252566d3546fb51de13756957fc4325fe04ac2e9dab27f2bb83aeacbf8a"
    sha256 cellar: :any,                 arm64_big_sur:  "52173ec7a2ea6e8549caf29df6798510d919c6702fc8c04040b5b0ce90e51f3e"
    sha256 cellar: :any,                 ventura:        "968b17275709f3bc7b9177771c3fc2eece67db206d2afb225075e7ed62c1b974"
    sha256 cellar: :any,                 monterey:       "010e67e29eff3d1c84ce1287fc9cb25dbca2f72e53cb7561aa148e5d9e432835"
    sha256 cellar: :any,                 big_sur:        "e92251b5b918108a76bbdadc1c9096c5484699cc7a841e9e346d2e8832d4430d"
    sha256 cellar: :any,                 catalina:       "066e8d93a82912709539b99c393e0063331502e57b8e8ba94d8531fb827fa656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "927e5bf029cbde5f87ab0da8b0539c862c0d9c60ff7cf0263eb216956763e8fa"
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
