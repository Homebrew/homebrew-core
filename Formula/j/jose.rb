class Jose < Formula
  desc "C-language implementation of Javascript Object Signing and Encryption"
  homepage "https://github.com/latchset/jose"
  url "https://github.com/latchset/jose/releases/download/v14/jose-14.tar.xz"
  sha256 "cee329ef9fce97c4c025604a8d237092f619aaa9f6d35fdf9d8c9052bc1ff95b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:    "7535c3d81eff311b23cf1884439712bb31db60bddd029c750517c64e95e5a75d"
    sha256 cellar: :any, arm64_sequoia:  "2bc631abff8a3ef0688dad54e842ea31860feb6c6b4b4ea01fcc3a22044dd16d"
    sha256 cellar: :any, arm64_sonoma:   "1af1eb0f697cd897bbedac36674670646b82cae369c752f4718500f5f1f324ef"
    sha256 cellar: :any, arm64_ventura:  "77b2d20d1a63a7f669930cdb9d8804722ed939a10efa9634c1f7635e61643634"
    sha256 cellar: :any, arm64_monterey: "4e01f021271f496483c1ce088c3c717eca63cee78498a2ecc778ca75e65f76bd"
    sha256 cellar: :any, sonoma:         "8bf8223dfd601b5631333198719e64e9c7b529e4a5d9e86192d181d6c8926f99"
    sha256 cellar: :any, ventura:        "1a670df4a652c8ffd615947a16be8a8867135d4b34e2081744a075c898d6cd79"
    sha256 cellar: :any, monterey:       "4301c9a1347a66f4b8065e0e78725bab058a264f1031c35cf4c92881af350492"
    sha256               arm64_linux:    "8a7e9b9bcc8ad20d55fb7fd4e393d83ecd51962cadcebd467d357ceade17ddf6"
    sha256               x86_64_linux:   "ebb309c88f0a9cf0d4a2ab3c13015ebecf876991941b9ed6a2de2dbc9f6a7adb"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "jansson"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  # Apply upstream PR to fix build on macOS to use `-exported_symbol`
  # PR ref: https://github.com/latchset/jose/pull/163
  patch do
    url "https://github.com/latchset/jose/commit/228d6782235238ed0d03eb2443caf530b377ffd5.patch?full_index=1"
    sha256 "14e147b1541a915badefa46535999c17fe3f04d2ba4754775b928e4d5e97ce1a"
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
