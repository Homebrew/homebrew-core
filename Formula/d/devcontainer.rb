require "language/node"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.58.0.tgz"
  sha256 "907fd38f2ce422e3eef1fe0752bf5cf0388e4addde6764e339876ae08222713e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d61e04ed4bb4c9e225783d1a6b196dd6927e217d6128163731ba08dcf7586159"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d61e04ed4bb4c9e225783d1a6b196dd6927e217d6128163731ba08dcf7586159"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d61e04ed4bb4c9e225783d1a6b196dd6927e217d6128163731ba08dcf7586159"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd4b3cfddd4ce074201877ec941e950e6f667e8d9eb053ca518d8685c4403805"
    sha256 cellar: :any_skip_relocation, ventura:        "cd4b3cfddd4ce074201877ec941e950e6f667e8d9eb053ca518d8685c4403805"
    sha256 cellar: :any_skip_relocation, monterey:       "cd4b3cfddd4ce074201877ec941e950e6f667e8d9eb053ca518d8685c4403805"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d61e04ed4bb4c9e225783d1a6b196dd6927e217d6128163731ba08dcf7586159"
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
