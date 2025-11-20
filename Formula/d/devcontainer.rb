class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.80.2.tgz"
  sha256 "de4f666cedddd1ea29e4c0972c49248ed897ffe7946e95d219ecbc061432179a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c03b8bb0f87ad35c7bb65096f12d4b80bac196ecc6a2fcb62d1bf501510bd812"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/devcontainer --version")

    ENV["DOCKER_HOST"] = File::NULL
    # Modified .devcontainer/devcontainer.json from CLI example:
    # https://github.com/devcontainers/cli#try-out-the-cli
    (testpath/".devcontainer.json").write <<~JSON
      {
        "name": "devcontainer-homebrew-test",
        "image": "mcr.microsoft.com/devcontainers/rust:0-1-bullseye"
      }
    JSON
    output = shell_output("#{bin}/devcontainer up --workspace-folder .", 1)
    assert_match '{"outcome":"error","message":"', output
  end
end
