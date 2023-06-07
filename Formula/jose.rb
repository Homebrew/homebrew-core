class Jose < Formula
  desc "C-language implementation of Javascript Object Signing and Encryption"
  homepage "https://github.com/latchset/jose"
  url "https://github.com/latchset/jose/releases/download/v11/jose-11.tar.xz"
  sha256 "e272afe7717e22790c383f3164480627a567c714ccb80c1ee96f62c9929d8225"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "21f4ddb24fe7718c027343713fb09aab4cbcf6d4c096f6e3fe8e09bd2e459344"
    sha256 cellar: :any, arm64_monterey: "551e1333f5bac04c13a4a2cf957ea2da84fb8c9d34a6ea18f8a661b9307bbb08"
    sha256 cellar: :any, arm64_big_sur:  "16e0db736b62521077a5ab096d43f0fd2aec7ea89a3f4839f71814582c268308"
    sha256 cellar: :any, ventura:        "f0ac20b30d42d9ddd0ef62458059475c50b236ce8d163d7ff26ad33eeffa8ee9"
    sha256 cellar: :any, monterey:       "7ef2c4173e81fbc601be37ac515d41b5240fa69ad2a252c67c9fe13d22530f51"
    sha256 cellar: :any, big_sur:        "3dac5c9fd2153330aebae3f18438eb9833ab8b524ca1e524828c5ef398d252a0"
    sha256 cellar: :any, catalina:       "29a910cbfe5af5c12b8f007e1fe7abacc167eb6875f76e67260de54fb3911825"
    sha256               x86_64_linux:   "dbfb98cddbd5634d5a96d6a036949fd7f664d1cd5a84ee33bf9ee934a0f88597"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "meson", *std_meson_args, "build"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"jose", "jwk", "gen", "-i", '{"alg": "A128GCM"}', "-o", "oct.jwk"
    system bin/"jose", "jwk", "gen", "-i", '{"alg": "RSA1_5"}', "-o", "rsa.jwk"
    system bin/"jose", "jwk", "pub", "-i", "rsa.jwk", "-o", "rsa.pub.jwk"
    system "echo hi | #{bin}/jose jwe enc -I - -k rsa.pub.jwk -o msg.jwe"
    output = shell_output("#{bin}/jose jwe dec -i msg.jwe -k rsa.jwk 2>&1")
    assert_equal "hi", output.chomp
    output = shell_output("#{bin}/jose jwe dec -i msg.jwe -k oct.jwk 2>&1", 1)
    assert_equal "Unwrapping failed!", output.chomp
  end
end
