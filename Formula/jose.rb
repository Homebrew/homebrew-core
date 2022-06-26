class Jose < Formula
  desc "C-language implementation of Javascript Object Signing and Encryption"
  homepage "https://github.com/latchset/jose"
  url "https://github.com/latchset/jose/releases/download/v11/jose-11.tar.xz"
  sha256 "e272afe7717e22790c383f3164480627a567c714ccb80c1ee96f62c9929d8225"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_monterey: "fce30dc2e458c01b3c429b6b9c140effdf487d2fa3b42a93d498779d070d5c67"
    sha256 cellar: :any, arm64_big_sur:  "a3a76d8b25def2f572513ddf580cd35f575a45c1b505c0ac781ea47d0bac4cab"
    sha256 cellar: :any, monterey:       "9a8d9d96d80bc042f75bda7c54482ef35210574786c4b3458e6051e363ea3719"
    sha256 cellar: :any, big_sur:        "7b5124a9d57f6a8ad4dfb85e706a4061cf52bfd423280198b7dcc0035158a9a8"
    sha256 cellar: :any, catalina:       "4fd0e6dc8ea1c333814995ba8cb855a6ee49d0db5cfd78272a418e981a4beb20"
    sha256 cellar: :any, mojave:         "6a6b10dbb8a8f3c6418bc35da20c5847befebcc71e1f96af00a047ccdcaa1752"
    sha256               x86_64_linux:   "e091a0517d325bb732b082977f78b8cfe30f423dd29a8389665d900848a22b92"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
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
