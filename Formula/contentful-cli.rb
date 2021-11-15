require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.9.30.tgz"
  sha256 "2fa98e8d41720448d124e5cbec5bc962c87568b22f585aa4c5501d0b289f653d"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "801eb1e5c261d2ea87121a7d784ef64d70f54b562523991298811a1a4b9bfef1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "801eb1e5c261d2ea87121a7d784ef64d70f54b562523991298811a1a4b9bfef1"
    sha256 cellar: :any_skip_relocation, monterey:       "d045ba1bb032958c0224279beb7b565cb69a092778e9dae6fd234c11c44f7457"
    sha256 cellar: :any_skip_relocation, big_sur:        "d045ba1bb032958c0224279beb7b565cb69a092778e9dae6fd234c11c44f7457"
    sha256 cellar: :any_skip_relocation, catalina:       "d045ba1bb032958c0224279beb7b565cb69a092778e9dae6fd234c11c44f7457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a61243c9a222402ffebd476cb46dac74e357d1489655b77435facc3d303c599c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
