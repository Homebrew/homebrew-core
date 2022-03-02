require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-9.10.0.tgz"
  sha256 "018ce40a6e366138fe0f148635309a04f3bb549d693b0bf4ad0899234d8c6181"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a31f41e1611c31794832d785dd98ac10e0eeba00ef471188128e16f7a2589f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a31f41e1611c31794832d785dd98ac10e0eeba00ef471188128e16f7a2589f0"
    sha256 cellar: :any_skip_relocation, monterey:       "e5a3dbee44173fcc482e784a5e949ea28e0583e4f71780530dd6d1dc962c53ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5a3dbee44173fcc482e784a5e949ea28e0583e4f71780530dd6d1dc962c53ed"
    sha256 cellar: :any_skip_relocation, catalina:       "e5a3dbee44173fcc482e784a5e949ea28e0583e4f71780530dd6d1dc962c53ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5692828fc35a8ff3195c9a9367329fa15c1d51c3402c883e65d7f130577d2cd"
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
