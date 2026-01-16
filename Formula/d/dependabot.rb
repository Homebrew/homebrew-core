class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://github.com/dependabot/cli/archive/refs/tags/v1.81.0.tar.gz"
  sha256 "0ebd3ee1be5f17ffdc9873899f6606bd287efcc9a6ce1a954450c2cc3d8f3205"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4459798dc0e15e89a5e73e7ac72fc28596ce32ca0e844086ab62e2bb237360e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4459798dc0e15e89a5e73e7ac72fc28596ce32ca0e844086ab62e2bb237360e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4459798dc0e15e89a5e73e7ac72fc28596ce32ca0e844086ab62e2bb237360e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c4b06c7d6e46d894f29e88a1e7d2da2dd6485f64397d03b08c55d809b2140e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a033eecba1926bc6b278ab4b8c9c5fdb2171cb46168a358855aba5111448fe65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a559265d4280e80b29e327776504011be8201ebbc11e50c8d44e52f67cadd5a"
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
