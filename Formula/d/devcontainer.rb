class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.72.0.tgz"
  sha256 "dce95550333869e03660f98d4963f898f204af9a961f324ff2b6be048a4704db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b23eec0465a7e0cb536cc57c61b0e2f2d0701cf5eb0aa2a0f298b6ae7673e4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b23eec0465a7e0cb536cc57c61b0e2f2d0701cf5eb0aa2a0f298b6ae7673e4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b23eec0465a7e0cb536cc57c61b0e2f2d0701cf5eb0aa2a0f298b6ae7673e4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd463e73fb6bb6ba250b87e5e418642d6d68ff6b81c779b6a087d4ba3ea8db6d"
    sha256 cellar: :any_skip_relocation, ventura:       "fd463e73fb6bb6ba250b87e5e418642d6d68ff6b81c779b6a087d4ba3ea8db6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b23eec0465a7e0cb536cc57c61b0e2f2d0701cf5eb0aa2a0f298b6ae7673e4d"
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
