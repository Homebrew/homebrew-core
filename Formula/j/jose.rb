class Jose < Formula
  desc "C-language implementation of Javascript Object Signing and Encryption"
  homepage "https://github.com/latchset/jose"
  url "https://github.com/latchset/jose/releases/download/v15/jose-15.tar.xz"
  sha256 "1d055c445392aa48d709ecd6e56220384ae2b480496e270818bddf1f219c8659"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ebeacbca6fbc189e7b40371c0e6645a1a01403df4be6c4f12f073e79381332dd"
    sha256 cellar: :any, arm64_sequoia: "0fccea7942cf37c3ada334a0edaaec4344182cba2cde93c741688d8d260e479f"
    sha256 cellar: :any, arm64_sonoma:  "2f2a2ba153eaa7a4a0a27be387117bc111f385baf2618c9febcb775a7909fecf"
    sha256 cellar: :any, sonoma:        "38f781c8547b8e2a03c958b9365ba886b697832036afa8aa921c0061dc94aa69"
    sha256               arm64_linux:   "c58b5053903cf8aa825273689558d7d028be30cad22c18f7075ee554f0e07839"
    sha256               x86_64_linux:  "bad3165cfa1980a89b0dcaa066bb8f68ef172462b337853665d70dbdba20d716"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "jansson"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
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
