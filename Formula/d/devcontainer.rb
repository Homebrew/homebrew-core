require "language/node"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.52.1.tgz"
  sha256 "920f1c7294842301aaeec58e5dd03c64f56b6598e4737a110daaed5265800b7f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6f06e893f93030279ade15927140b7abd06ca7fb85b28ec59cd17d2a06becc5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f06e893f93030279ade15927140b7abd06ca7fb85b28ec59cd17d2a06becc5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f06e893f93030279ade15927140b7abd06ca7fb85b28ec59cd17d2a06becc5e"
    sha256 cellar: :any_skip_relocation, sonoma:         "cce968481f6946b673bf3d95b6f0db4d2d1a7c19c0e866455d59c48f0facd224"
    sha256 cellar: :any_skip_relocation, ventura:        "cce968481f6946b673bf3d95b6f0db4d2d1a7c19c0e866455d59c48f0facd224"
    sha256 cellar: :any_skip_relocation, monterey:       "cce968481f6946b673bf3d95b6f0db4d2d1a7c19c0e866455d59c48f0facd224"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b73187994fe793200274b3b83a318b2929034212dab9cfed8e5f29184ff723b4"
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
