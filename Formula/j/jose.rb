class Jose < Formula
  desc "C-language implementation of Javascript Object Signing and Encryption"
  homepage "https://github.com/latchset/jose"
  url "https://github.com/latchset/jose/releases/download/v14/jose-14.tar.xz"
  sha256 "cee329ef9fce97c4c025604a8d237092f619aaa9f6d35fdf9d8c9052bc1ff95b"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1d1b44fa59d852fc5088c893377558254626666ed7d0a28b40aff059b7453359"
    sha256 cellar: :any, arm64_sequoia: "c3766ad0a6e7d09b4ca772789051e0ed65b1d60136ccb21668df7fda68900928"
    sha256 cellar: :any, arm64_sonoma:  "7533d3b756c99c3cc68847697bd3605114907ea901e3c169d7037ffaf2aea6d5"
    sha256 cellar: :any, sonoma:        "4bfce15bb7ef905f0329b293ef0a774f47d9549842909b162b684a7ec4ee8f59"
    sha256               arm64_linux:   "fb5ffc55b53631aeabc6510efcff62b5efa329d81e49f914e7a7c13a2ff48294"
    sha256               x86_64_linux:  "82bb7d5297fdb066ffc49d5995ad133dee5943b7b80915651a95197d52de164a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "jansson"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
