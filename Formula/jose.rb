class Jose < Formula
  desc "C-language implementation of Javascript Object Signing and Encryption"
  homepage "https://github.com/latchset/jose"
  url "https://github.com/latchset/jose/releases/download/v10/jose-10.tar.bz2"
  sha256 "5c9cdcfb535c4d9f781393d7530521c72b1dd81caa9934cab6dd752cc7efcd72"
  revision 1

  bottle do
    cellar :any
    sha256 "50f8497d1d0327f756b04018d37cb9b7b623abb9ff7809085d7e9c2ae2bf1e8d" => :mojave
    sha256 "9b4f2fa1305f31524b044a6ded2581e31eda203996061a6e9e57f64688883b9d" => :high_sierra
    sha256 "8961c873e24e87730465ec0efcfa6190e9359d76e708d1a68aa49df1bb3da827" => :sierra
    sha256 "b527c51d08dc44eff7005a75eaaa5e5d89fe950a0bd55eec8929431c94877826" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
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
