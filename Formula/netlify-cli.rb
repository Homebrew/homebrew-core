require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.37.37.tgz"
  sha256 "9dd3024c7968ed6d7d5df8818a0bc161b05e0bfd82156ba095290493901ee90e"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c597998e20dfee97d549b791efbe735927be9fc80f6e3881b29592d7c3b50e87"
    sha256 cellar: :any_skip_relocation, big_sur:       "6c2a51607ff6c07ab5850cbcb37f0d3ca9dbf6bed250f2cb4267007ccd8321b2"
    sha256 cellar: :any_skip_relocation, catalina:      "6c2a51607ff6c07ab5850cbcb37f0d3ca9dbf6bed250f2cb4267007ccd8321b2"
    sha256 cellar: :any_skip_relocation, mojave:        "6c2a51607ff6c07ab5850cbcb37f0d3ca9dbf6bed250f2cb4267007ccd8321b2"
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
