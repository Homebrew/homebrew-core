require "language/node"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.59.1.tgz"
  sha256 "254b3ecf34c16c4ea77b3a28fcc2e1620ecd8a4df2fbe41de4b00455b90114ee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ecfaa529649d6de294d9135da5fdd2dcccfbf823101a09ba713ea63a93cbb0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ecfaa529649d6de294d9135da5fdd2dcccfbf823101a09ba713ea63a93cbb0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ecfaa529649d6de294d9135da5fdd2dcccfbf823101a09ba713ea63a93cbb0d"
    sha256 cellar: :any_skip_relocation, sonoma:         "283b199039275b84633e7c285c4ccfc8567519738338685a98093196039a7339"
    sha256 cellar: :any_skip_relocation, ventura:        "283b199039275b84633e7c285c4ccfc8567519738338685a98093196039a7339"
    sha256 cellar: :any_skip_relocation, monterey:       "283b199039275b84633e7c285c4ccfc8567519738338685a98093196039a7339"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ecfaa529649d6de294d9135da5fdd2dcccfbf823101a09ba713ea63a93cbb0d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["DOCKER_HOST"] = "/dev/null"
    # Modified .devcontainer/devcontainer.json from CLI example:
    # https://github.com/devcontainers/cli#try-out-the-cli
    (testpath/".devcontainer.json").write <<~EOS
      {
        "name": "devcontainer-homebrew-test",
        "image": "mcr.microsoft.com/devcontainers/rust:0-1-bullseye"
      }
    EOS
    output = shell_output("#{bin}/devcontainer up --workspace-folder .", 1)
    assert_match '{"outcome":"error","message":"', output
  end
end
