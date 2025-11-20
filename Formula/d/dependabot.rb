class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://github.com/dependabot/cli/archive/refs/tags/v1.78.1.tar.gz"
  sha256 "2608917f382330e44b26b50f3b331bbe30be91703f7e7b33387a7b3f7f09c3e3"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56798ea99e6514a7cfd75e48415a37eadb640479eb66b8e372dacf0d190c3ad2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56798ea99e6514a7cfd75e48415a37eadb640479eb66b8e372dacf0d190c3ad2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56798ea99e6514a7cfd75e48415a37eadb640479eb66b8e372dacf0d190c3ad2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e88523e6efb0b947945c35ef41b7906ac161a5139f2e76ae32eb4bfeb2b1eed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dd87078095cf7f12318b32dcc92316896d2dafefd1c658db85e862273611ae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e00c1677db3ef0f60a8c97ad750bdb136b64acb7e3c281a500549f4a21d779da"
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
