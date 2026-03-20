class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://github.com/dependabot/cli/archive/refs/tags/v1.84.0.tar.gz"
  sha256 "cdcea95b4e5849e40dba7e9cfba8103477ab4a5ecd8bf56047e4e4e2c2fd6205"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51b997583e916ece75ef1fedcf1f44c943c2f18444930d11cc0028fcdc30ffe8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51b997583e916ece75ef1fedcf1f44c943c2f18444930d11cc0028fcdc30ffe8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51b997583e916ece75ef1fedcf1f44c943c2f18444930d11cc0028fcdc30ffe8"
    sha256 cellar: :any_skip_relocation, sonoma:        "82dbb5652bac10bdece8b800e8d24c98dab88462c3d9f0edd58aacdbfe6ae44f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed6cd5efc65201241104cc74418293afbd97a8b04f27ae4fa8f286943920f906"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "903df764baf390be100ac3a760cbc31bbbc7fd371b76f1826e4b606c06949689"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/dependabot/cli/cmd/dependabot/internal/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dependabot"

    generate_completions_from_executable(bin/"dependabot", shell_parameter_format: :cobra)
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    assert_match("dependabot version #{version}", shell_output("#{bin}/dependabot --version"))
    output = shell_output("#{bin}/dependabot update bundler Homebrew/homebrew 2>&1", 1)
    assert_match("Cannot connect to the Docker daemon", output)
  end
end
