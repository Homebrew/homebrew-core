class BuildpulseTestReporter < Formula
  desc "Connect your CI to BuildPulse to detect, track, and rank flaky tests"
  homepage "https://buildpulse.io"
  url "https://github.com/buildpulse/test-reporter/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "5fecd09586dd5e28e18278c55dc60d1c69a6fbf8aeaa437d72700c2d601a530b"
  license "MIT"
  head "https://github.com/buildpulse/test-reporter.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cde69112052e2eae04c9236383b62d5ee040e9e4281ee9ab4e749ad5bb316d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cde69112052e2eae04c9236383b62d5ee040e9e4281ee9ab4e749ad5bb316d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cde69112052e2eae04c9236383b62d5ee040e9e4281ee9ab4e749ad5bb316d0"
    sha256 cellar: :any_skip_relocation, ventura:        "69bd8a6950f1c4dbdc2ff34fef0883356582795b5f3e5903f26df4aca6bb9a13"
    sha256 cellar: :any_skip_relocation, monterey:       "69bd8a6950f1c4dbdc2ff34fef0883356582795b5f3e5903f26df4aca6bb9a13"
    sha256 cellar: :any_skip_relocation, big_sur:        "69bd8a6950f1c4dbdc2ff34fef0883356582795b5f3e5903f26df4aca6bb9a13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "221768ce6503a0a64cc5493cb6fd94a3e82e14634cb6e4f4f64c2efa33637577"
  end

  depends_on "go" => :build

  def install
    goldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: goldflags), "./cmd/test-reporter"
  end

  test do
    binary = bin/"buildpulse-test-reporter"
    assert_match version.to_s, shell_output("#{binary} --version")

    fake_dir = "im-not-real"
    assert_match "Received args: #{fake_dir}", shell_output("#{binary} submit #{fake_dir}", 1)
  end
end
