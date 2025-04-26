class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.76.0.tgz"
  sha256 "3725a3db0d9c42c2eae21cc32972674288f6c5d55b5b11c3b09fc7fc53dd9f26"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a478f446f6efb19efd7fb3f25348f67525fe323b5ab11415fad17169287d7b3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a478f446f6efb19efd7fb3f25348f67525fe323b5ab11415fad17169287d7b3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a478f446f6efb19efd7fb3f25348f67525fe323b5ab11415fad17169287d7b3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "652c9facf4c49a046f52aee5148b959161a57689c37281ba9466e857c52ee20a"
    sha256 cellar: :any_skip_relocation, ventura:       "652c9facf4c49a046f52aee5148b959161a57689c37281ba9466e857c52ee20a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a478f446f6efb19efd7fb3f25348f67525fe323b5ab11415fad17169287d7b3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a478f446f6efb19efd7fb3f25348f67525fe323b5ab11415fad17169287d7b3f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
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
