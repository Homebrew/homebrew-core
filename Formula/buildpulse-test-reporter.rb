class BuildpulseTestReporter < Formula
  desc "Connect your CI to BuildPulse to detect, track, and rank flaky tests"
  homepage "https://buildpulse.io"
  url "https://github.com/buildpulse/test-reporter/archive/refs/tags/v0.24.2.tar.gz"
  sha256 "63604db79aa165eff8fb31e08432b4c95685748b44022dd2b97f1bf5cca71e01"
  license "MIT"
  head "https://github.com/buildpulse/test-reporter.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2fa09b5d9543913c69456a94c24081dda79a8820325e4cd2827a40d245d2cf7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2fa09b5d9543913c69456a94c24081dda79a8820325e4cd2827a40d245d2cf7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2fa09b5d9543913c69456a94c24081dda79a8820325e4cd2827a40d245d2cf7"
    sha256 cellar: :any_skip_relocation, ventura:        "40aa639699c9deddf13f1d9a033fc98a4410d5ef6a53bd1d3ce2c74ba39fba04"
    sha256 cellar: :any_skip_relocation, monterey:       "40aa639699c9deddf13f1d9a033fc98a4410d5ef6a53bd1d3ce2c74ba39fba04"
    sha256 cellar: :any_skip_relocation, big_sur:        "40aa639699c9deddf13f1d9a033fc98a4410d5ef6a53bd1d3ce2c74ba39fba04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af2f7331a432d319b399d81ac53eadd8191014dda93318451ee6ce01b2016f40"
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
