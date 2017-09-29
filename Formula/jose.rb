class Jose < Formula
  desc "C-language implementation of Javascript Object Signing and Encryption"
  homepage "https://github.com/latchset/jose"
  url "https://github.com/latchset/jose/releases/download/v10/jose-10.tar.bz2"
  sha256 "5c9cdcfb535c4d9f781393d7530521c72b1dd81caa9934cab6dd752cc7efcd72"

  bottle do
    cellar :any
    sha256 "02a0575836a706ad225c6d84df7151036d4edc75078f62c19ae05c7a90586d19" => :high_sierra
    sha256 "8daa4c108b2bf94d1ebec9079d4375a5ca214c09d45f3f29cd541953d6262653" => :sierra
    sha256 "7729b474946230922fc6d6c9f6799d0a486bd2d6a8cf283f18f2e1e9257ee928" => :el_capitan
    sha256 "1ef50f01624ba2d71de37f775ed054734fab893b0b4c6b12e9ca8cab6ad8f581" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "openssl"

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
