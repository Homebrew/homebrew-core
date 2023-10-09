require "language/node"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.52.0.tgz"
  sha256 "039054bea09048d7095c8bbfff6aa01c7ee21c860f5e581c0c744fb651132e20"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30cace6610d2af91c7b6cfc9d51b34133235ee28e776c3bbe828794c2117fec2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30cace6610d2af91c7b6cfc9d51b34133235ee28e776c3bbe828794c2117fec2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30cace6610d2af91c7b6cfc9d51b34133235ee28e776c3bbe828794c2117fec2"
    sha256 cellar: :any_skip_relocation, sonoma:         "188241019d4bb92698519a4fe4dd66df33b35ae08f3d853f65466f9c91b26d5b"
    sha256 cellar: :any_skip_relocation, ventura:        "188241019d4bb92698519a4fe4dd66df33b35ae08f3d853f65466f9c91b26d5b"
    sha256 cellar: :any_skip_relocation, monterey:       "188241019d4bb92698519a4fe4dd66df33b35ae08f3d853f65466f9c91b26d5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80b89c379799e8862c5befb3cd0070acd1bcaf5a7a3176524b02e0049b653e3f"
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
