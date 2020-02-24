class Jose < Formula
  desc "C-language implementation of Javascript Object Signing and Encryption"
  homepage "https://github.com/latchset/jose"
  url "https://github.com/latchset/jose/releases/download/v10/jose-10.tar.bz2"
  sha256 "5c9cdcfb535c4d9f781393d7530521c72b1dd81caa9934cab6dd752cc7efcd72"
  revision 1

  bottle do
    cellar :any
    sha256 "359c58b36bb631623273a77d13431f29ff467e9602f1500f9e4fa761ed0719be" => :catalina
    sha256 "358a06afd49f1390ca917969dbb434a75a91bd0de3d8ac981d3eab969670cfe2" => :mojave
    sha256 "7a84bdaece281b98dc4a7b0a7fbf05976297126966d14ee2862e007521cdd4ea" => :high_sierra
    sha256 "1669bf780ac07ee9a7d216185139aaa6e5c44add352e6da25f02c079694e7ad1" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

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
