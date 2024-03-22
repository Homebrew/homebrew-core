require "language/node"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.57.0.tgz"
  sha256 "b5965365bffbb95e812928359ee1778bfe376047b7d43dcc862b5ad528ac41e3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd62dd4838ebcd2db280a83429fe10f6905cffc101dc577c2d45329f7f5b36da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd62dd4838ebcd2db280a83429fe10f6905cffc101dc577c2d45329f7f5b36da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd62dd4838ebcd2db280a83429fe10f6905cffc101dc577c2d45329f7f5b36da"
    sha256 cellar: :any_skip_relocation, sonoma:         "686cd66345299343191fc4c6326cc9989fc0108a8b06af56b440f7f1918f91ae"
    sha256 cellar: :any_skip_relocation, ventura:        "686cd66345299343191fc4c6326cc9989fc0108a8b06af56b440f7f1918f91ae"
    sha256 cellar: :any_skip_relocation, monterey:       "686cd66345299343191fc4c6326cc9989fc0108a8b06af56b440f7f1918f91ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd62dd4838ebcd2db280a83429fe10f6905cffc101dc577c2d45329f7f5b36da"
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
