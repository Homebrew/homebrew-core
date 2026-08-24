class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.88.0.tgz"
  sha256 "5cac67ef43a7150734e952b6b8ceb70949a492a090e79a0c8ed9e848f0aae72b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "536c2244d7a86fcd1103d9f42c3bd1067daba9743567acff67c5c38bda275044"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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
