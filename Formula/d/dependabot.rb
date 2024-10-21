class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://github.com/dependabot/cli/archive/refs/tags/v1.55.0.tar.gz"
  sha256 "14f6c59e32544772d28412f0e616e07b23d70232019d582b1237068fe12a41c7"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acad50fe4b422ac074d9a4fbe5565e33e337d20e631c6b6035ded252294e43ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acad50fe4b422ac074d9a4fbe5565e33e337d20e631c6b6035ded252294e43ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "acad50fe4b422ac074d9a4fbe5565e33e337d20e631c6b6035ded252294e43ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fbeec8990c548013f7d0fb9157ae1f2c6daef0628ef2f62237b19cdba1de644"
    sha256 cellar: :any_skip_relocation, ventura:       "0fbeec8990c548013f7d0fb9157ae1f2c6daef0628ef2f62237b19cdba1de644"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcb81b953bfdfb5e1a7799eb96a9869877b66f3b96ee6f7f1b42604b3130d335"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/dependabot/cli/cmd/dependabot/internal/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dependabot"

    generate_completions_from_executable(bin/"dependabot", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    assert_match("dependabot version #{version}", shell_output("#{bin}/dependabot --version"))
    output = shell_output("#{bin}/dependabot update bundler Homebrew/homebrew 2>&1", 1)
    assert_match("Cannot connect to the Docker daemon", output)
  end
end
