require "language/node"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.50.2.tgz"
  sha256 "65d66a4df6b2c017be9ae0f0a078169c65cd87276b9aca1d852a96af0372d8fb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9bebcecd8a1894650bc93e2a6de6633a660935b592957d5bb79f706ce06fd2fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bebcecd8a1894650bc93e2a6de6633a660935b592957d5bb79f706ce06fd2fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9bebcecd8a1894650bc93e2a6de6633a660935b592957d5bb79f706ce06fd2fc"
    sha256 cellar: :any_skip_relocation, ventura:        "2a709ed9c968d4993cf0023e17304407523c98f95be8698a1f23b3e5311faf3a"
    sha256 cellar: :any_skip_relocation, monterey:       "2a709ed9c968d4993cf0023e17304407523c98f95be8698a1f23b3e5311faf3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a709ed9c968d4993cf0023e17304407523c98f95be8698a1f23b3e5311faf3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fec49be4140da372785061b4eab8694c0389f86b44e63609bc3499354f33cbb"
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
