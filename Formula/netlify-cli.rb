require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-12.0.10.tgz"
  sha256 "8450b270adf0e102d53f14570bfcc17ca431319cb07322c18f62625ca66faab8"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4dca91bb508e4db6d54d79351ace8327590b6a5558df010ee52086a144a82673"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4dca91bb508e4db6d54d79351ace8327590b6a5558df010ee52086a144a82673"
    sha256 cellar: :any_skip_relocation, monterey:       "c965cf6b2c966b528812a8a313f85c871413e9c1d2bc86661750bc1c5b6d4796"
    sha256 cellar: :any_skip_relocation, big_sur:        "c965cf6b2c966b528812a8a313f85c871413e9c1d2bc86661750bc1c5b6d4796"
    sha256 cellar: :any_skip_relocation, catalina:       "c965cf6b2c966b528812a8a313f85c871413e9c1d2bc86661750bc1c5b6d4796"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e97d23e2bdf9bb58460683b135110da209d298203e592ea0f90a2c877813ce1"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end
