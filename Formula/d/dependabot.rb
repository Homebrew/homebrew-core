class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://github.com/dependabot/cli/archive/refs/tags/v1.96.0.tar.gz"
  sha256 "2c8401f1b98e2b42851e7670599e473458af5cd2ffe02c35383c875158c3b6f9"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b9c162d2668c83ea0adcf1b580dc3decc9508c1d6fb15aa2fc43f44c132a714b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b9c162d2668c83ea0adcf1b580dc3decc9508c1d6fb15aa2fc43f44c132a714b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b9c162d2668c83ea0adcf1b580dc3decc9508c1d6fb15aa2fc43f44c132a714b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "319367f6c59bbe214f2c3695b4aa76701e063f3e4883f055d6b82cd12b798d33"
    sha256 cellar: :any,                 x86_64_linux:      "a63d36adeca466e94f4df2deef557a4b95a7848634197b0c8bbab698906db3ad"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/dependabot/cli/cmd/dependabot/internal/cmd.version=#{version}]
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
