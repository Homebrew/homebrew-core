require "language/node"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.64.0.tgz"
  sha256 "88a2244b82be2a15ba8612846b6e47bb79554480587789c05f648d0a47d3a8d4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "263ded90f4a2fc5752681a9916f963dc14bc18d112ef2a95af378c93851dcee5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "263ded90f4a2fc5752681a9916f963dc14bc18d112ef2a95af378c93851dcee5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "263ded90f4a2fc5752681a9916f963dc14bc18d112ef2a95af378c93851dcee5"
    sha256 cellar: :any_skip_relocation, sonoma:         "2970a47624f1cad5d1db1d4e0a5d1ed28f9380b7e9a77a84519fc5611e2b06da"
    sha256 cellar: :any_skip_relocation, ventura:        "2970a47624f1cad5d1db1d4e0a5d1ed28f9380b7e9a77a84519fc5611e2b06da"
    sha256 cellar: :any_skip_relocation, monterey:       "2970a47624f1cad5d1db1d4e0a5d1ed28f9380b7e9a77a84519fc5611e2b06da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa99ae509247d4a3909f4208a9b49dd52b47674121a3e2356a71d8f4aec27654"
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
