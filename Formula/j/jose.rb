class Jose < Formula
  desc "C-language implementation of Javascript Object Signing and Encryption"
  homepage "https://github.com/latchset/jose"
  url "https://github.com/latchset/jose/releases/download/v13/jose-13.tar.xz"
  sha256 "995a72678acb71a700907a2e6a2280e88a04dc14709094fe4ce828bc10aec3ed"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "8e0caec9dc2ea5d9d4619e6e0582f25cfe980d52317ad924bb7364983c4613b4"
    sha256 cellar: :any, arm64_ventura:  "e3d8eac6cbd436d72e86e3fab6ac6dbb697db1d6f2c53b969f79e01b72fd4af2"
    sha256 cellar: :any, arm64_monterey: "81ffce589a26b57b4d85c07c473506c8731c4b078450d9a0ae2c6b0f5211e9f0"
    sha256 cellar: :any, sonoma:         "95f3e40e0f6fe1a1b4c43681c3295f7d79141e78e9adac809cdcdadf27d4d66b"
    sha256 cellar: :any, ventura:        "751410cc5b6db3f32798b4388c9af2199a9b2d4dc85e7a1e09ceb9a616671083"
    sha256 cellar: :any, monterey:       "b846d7b234825ac94314a338c0d61b1d0d326fa6dceac02e1d74a2b1a7ea493c"
    sha256               x86_64_linux:   "ad952749f663ba18bcca3d8e6b30a953725000bd57b10b13337403aaeb3071b8"
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
