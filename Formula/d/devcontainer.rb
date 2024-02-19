require "language/node"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.56.2.tgz"
  sha256 "6f169c57fc7b9b9a5291938983d3a4a2ff2d0cf03302cf1b03986806097a1416"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "561699f27b10a8c5b4e78d13d16673ec97a93f9eb2b8bd7f925bf529edf4aa02"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "561699f27b10a8c5b4e78d13d16673ec97a93f9eb2b8bd7f925bf529edf4aa02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "561699f27b10a8c5b4e78d13d16673ec97a93f9eb2b8bd7f925bf529edf4aa02"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c385c470f6f1acd95ca9017d93109a34e31e10261270f37c36fb971d904cb9e"
    sha256 cellar: :any_skip_relocation, ventura:        "4c385c470f6f1acd95ca9017d93109a34e31e10261270f37c36fb971d904cb9e"
    sha256 cellar: :any_skip_relocation, monterey:       "4c385c470f6f1acd95ca9017d93109a34e31e10261270f37c36fb971d904cb9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "561699f27b10a8c5b4e78d13d16673ec97a93f9eb2b8bd7f925bf529edf4aa02"
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
