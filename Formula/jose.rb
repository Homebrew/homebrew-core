class Jose < Formula
  desc "C-language implementation of Javascript Object Signing and Encryption"
  homepage "https://github.com/latchset/jose"
  url "https://github.com/latchset/jose/releases/download/v11/jose-11.tar.xz"
  sha256 "e272afe7717e22790c383f3164480627a567c714ccb80c1ee96f62c9929d8225"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2cd4169ce2cfbcee491a79cf4ce414c33e663361ea3203d10f9d7c2cacab6864"
    sha256 cellar: :any, big_sur:       "0ec2b6ee1c5b94c0eee5edd20e8e619cf341afa0c16e5873abb5ba8afb0e6558"
    sha256 cellar: :any, catalina:      "359c58b36bb631623273a77d13431f29ff467e9602f1500f9e4fa761ed0719be"
    sha256 cellar: :any, mojave:        "358a06afd49f1390ca917969dbb434a75a91bd0de3d8ac981d3eab969670cfe2"
    sha256 cellar: :any, high_sierra:   "7a84bdaece281b98dc4a7b0a7fbf05976297126966d14ee2862e007521cdd4ea"
    sha256 cellar: :any, sierra:        "1669bf780ac07ee9a7d216185139aaa6e5c44add352e6da25f02c079694e7ad1"
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
