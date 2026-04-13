class Jose < Formula
  desc "C-language implementation of Javascript Object Signing and Encryption"
  homepage "https://github.com/latchset/jose"
  url "https://github.com/latchset/jose/releases/download/v14/jose-14.tar.xz"
  sha256 "cee329ef9fce97c4c025604a8d237092f619aaa9f6d35fdf9d8c9052bc1ff95b"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "67229f3071c21858f07f5a5f43072531c49e2397d161f8bf505f25ce0c9f2184"
    sha256 cellar: :any, arm64_sequoia: "55060e0f494136495d66e48db57e1fc04aa2822e5b3777c7fcd44bc34be2302a"
    sha256 cellar: :any, arm64_sonoma:  "03f0277a4eb033772af00607572e613da16fabaee01c6b7ff9e60dae8581b4da"
    sha256 cellar: :any, sonoma:        "e381e6924862e4d6184176e9945f51465c25fbb5ec580e0e7d29cfbfab1087df"
    sha256               arm64_linux:   "859ce789ed3684e96d57e5bf3c3146b63e5ae70fce3fc7d798a3f0af2e084286"
    sha256               x86_64_linux:  "7cc9ebb45c81fced9dbfece96ad5007a334bff37817cdd93605dcecfe9d67c0f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "jansson"
  depends_on "openssl@3"

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
