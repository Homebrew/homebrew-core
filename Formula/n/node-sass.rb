class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.93.2.tgz"
  sha256 "f31c563781e88a27f9bae738202eb38c3779f124043ced54da0c53e4fdbb83ac"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "0543415a282ad25c071ca2a163a9c658d3b83efc7fc50513a0f4418b611522f4"
    sha256                               arm64_sequoia: "2be11e5d585078fade8f05e2fec04b8fdefa27d8bb633b40efad574c154897cc"
    sha256                               arm64_sonoma:  "2e01beb06e4f4f4108fb633cf3bc36c1a7da9736217b422b2395da3f76f8461e"
    sha256                               sonoma:        "09984c128f39674166e0b98bb986a918a8c314afdd459d9896f0a57a2e3e0325"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f235f9d716d047651080db88d2dba0b55656a0f02ad3dad5a44b09992511e7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "636155ff85dabd53bc7296d500c83d1847e874ca5ad2c5585669945d526b76d1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end
