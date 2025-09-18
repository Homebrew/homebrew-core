class Pkcs11Tools < Formula
  desc "Tools to manage objects on PKCS#11 crypotographic tokens"
  homepage "https://github.com/Mastercard/pkcs11-tools"
  url "https://github.com/Mastercard/pkcs11-tools/releases/download/v2.6.0/pkcs11-tools-2.6.0.tar.gz"
  sha256 "5fcda842ed009dacef5d935f5d46bda81bdc26795737af525aa904655a640ba0"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "99d3a5104235020c9ba34054b886dff32a538917592f9b9a7d4535c26513b072"
    sha256 cellar: :any,                 arm64_sequoia:  "22183ecdec16099e7c38d97f5499deb1fbcb9236a9d4deb2c08fa22fd7007358"
    sha256 cellar: :any,                 arm64_sonoma:   "41dd63eb44f9015459c816515202120069605a31875d536a920ec87ede6c1990"
    sha256 cellar: :any,                 arm64_ventura:  "c1babe9a656e43094e4c1e824ae76eaf60111376d57a77e31c6e3c9186fed553"
    sha256 cellar: :any,                 arm64_monterey: "861b3b73c9e30599ddbb2fed03b89a6a648f74106d834551500971cdacbae820"
    sha256 cellar: :any,                 arm64_big_sur:  "a2f9db1cff53bf73aaaadd1117dd72f8aac42d38e7ef40b59b56be535e4067c1"
    sha256 cellar: :any,                 sonoma:         "2086010d622865bce37c477946bda04a16d7f488f7a9d7cee6ba94bad3708f80"
    sha256 cellar: :any,                 ventura:        "f98f64e004a340203e91c268d37751fec2426b8a1b6a3a4d910f7834176b8b3f"
    sha256 cellar: :any,                 monterey:       "d54d48ba1f3f92918c56441059b1da04a2231779e9f3a6ed67c036303d68499a"
    sha256 cellar: :any,                 big_sur:        "27d568c817878042985a01e7cdb1ee74da2904c8bd42c87f9eaf72496c0e7c68"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4de234bc0e7f615fe95f3ab3604d8d5915d2bfa2948f778fb10921b92c83dc2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "204de485eee7fdc9c63d60924bf2a2559bcddb2b13badbd60f97c8fcbd6ab4c3"
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
    system bin/"p11keygen", "-i", "test", "-k", "aes", "-b", "128", "encrypt"
    system bin/"p11kcv", "seck/test"
    system bin/"p11ls"
  end
end
