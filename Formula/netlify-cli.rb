require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.37.0.tgz"
  sha256 "88d4286dc20be66aa6425bdb410bcdcf61549287d63505ca776d037e28ad93b8"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a02eedb204e59c8bb12f84c7ebf9b4611c3c8c130d5b0ea6cd1d3f83f4a8bcd" => :catalina
    sha256 "a131478bf24174691348fc4389248732e653f38c567472731ead78e23aa6e5da" => :mojave
    sha256 "2d5a8e74e762b5138b9c6585a879b1a789be0393d0402fa637dbf4325612a1f4" => :high_sierra
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
