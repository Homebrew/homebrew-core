require "language/node"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.51.3.tgz"
  sha256 "9df443d100fe9231fbc8a8fb6d6fc1510f5b0e53acbb71f5afec8a86585d37c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79d4adfdbaba2a43254522649be21ff78c00a3cc9ce4c508638a0c251567d3dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79d4adfdbaba2a43254522649be21ff78c00a3cc9ce4c508638a0c251567d3dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79d4adfdbaba2a43254522649be21ff78c00a3cc9ce4c508638a0c251567d3dd"
    sha256 cellar: :any_skip_relocation, ventura:        "4950af82bdc20be1a991efa4830fdfbfbeb791c87278ba7067a2b8eb7637ab58"
    sha256 cellar: :any_skip_relocation, monterey:       "4950af82bdc20be1a991efa4830fdfbfbeb791c87278ba7067a2b8eb7637ab58"
    sha256 cellar: :any_skip_relocation, big_sur:        "4950af82bdc20be1a991efa4830fdfbfbeb791c87278ba7067a2b8eb7637ab58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff0395311ca44162251f1c96ef8c381c8f65407bea28b51af87fa9849fe6370d"
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
