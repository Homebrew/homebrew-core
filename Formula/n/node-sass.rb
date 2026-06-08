class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.100.0.tgz"
  sha256 "21c392fda32899b07c59a5e132f2503b72429ae47600bf205420e981214a4af9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f97b804d8f6495291234a0365263ada86580c1b95d986e9a63173be2af0812e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f97b804d8f6495291234a0365263ada86580c1b95d986e9a63173be2af0812e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f97b804d8f6495291234a0365263ada86580c1b95d986e9a63173be2af0812e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1234f5d5c26acfc2c5e481ad8d10ce74e306b2adfce4f34ec2a32b487961c99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "370e0514d0a8f205ccd55f08bff208c794c497adac573b1759cf0da401162f79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62856face0908d9fb41bc26dff3ff1b54327a0e513a0efb2c8a5476dd004e2e1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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
