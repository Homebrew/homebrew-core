class BuildpulseTestReporter < Formula
  desc "Connect your CI to BuildPulse to detect, track, and rank flaky tests"
  homepage "https://buildpulse.io"
  url "https://github.com/buildpulse/test-reporter/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "2defba6007ff0d90d40f915ea06e6f9df79c92b8e49d609eb2321a17e72b4efe"
  license "MIT"
  head "https://github.com/buildpulse/test-reporter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8058fc7befab1fca308927f42c006f5a07422d223db3bb61cb7dc963c6a6196f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e2f8443094f637f0248dab74dd5b35028588c5fb0b303116d1ef22dde5478d6"
    sha256 cellar: :any_skip_relocation, monterey:       "424c5626fbb0b4f867cf960270128df8fe9e82e4870d418545167681e72b9226"
    sha256 cellar: :any_skip_relocation, big_sur:        "92d337bcf1ad91fb6a2c6f891f020fad1f843dd37b772bf62160e5743fa58c6e"
    sha256 cellar: :any_skip_relocation, catalina:       "165d5540840fc4561cd434d9dc52a251570f899978b32f4fb6a126b579569c97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed7ac8faf11d2ad128f4410092400de20b0ffe8565b88ea946bc7a964f606cf6"
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
