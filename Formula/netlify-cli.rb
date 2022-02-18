require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-9.6.5.tgz"
  sha256 "88ca279ce6c49278fde81706fd31d50708243e210e3e9acccfdba30a3a08fbc2"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c082af2dc0fd07cf75b3089ebd91abc271110b53056df60ad8ee21bd95fb2655"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c082af2dc0fd07cf75b3089ebd91abc271110b53056df60ad8ee21bd95fb2655"
    sha256 cellar: :any_skip_relocation, monterey:       "ae8e147f27eb33ee4181d19dcf2e9fd4f692452ec51d5d559a878e393cffa352"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae8e147f27eb33ee4181d19dcf2e9fd4f692452ec51d5d559a878e393cffa352"
    sha256 cellar: :any_skip_relocation, catalina:       "ae8e147f27eb33ee4181d19dcf2e9fd4f692452ec51d5d559a878e393cffa352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8babe27280bb019f78beaecce8d85cd77ec013475bc888e8637dc37480e8615e"
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
