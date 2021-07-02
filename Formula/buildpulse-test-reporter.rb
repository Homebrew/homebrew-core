class BuildpulseTestReporter < Formula
  desc "Connect your CI to BuildPulse to detect, track, and rank flaky tests"
  homepage "https://buildpulse.io"
  url "https://github.com/buildpulse/test-reporter/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "132ae03496a17536b965fef2ccf4f53360fb760e9f83577c2ad0a4462716039f"
  license "MIT"
  head "https://github.com/buildpulse/test-reporter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d99ea6ed02c4778603f873bf3022c9855fa94cb5f50c424359a86b3952a0707c"
    sha256 cellar: :any_skip_relocation, big_sur:       "58b20d5b344f9eb1f1f0ec9dc0f7bf3593f070097d575afb8e3e500a66053d60"
    sha256 cellar: :any_skip_relocation, catalina:      "afc2be1dc54b07069ea86809ce6ac3f6b2a7f2f1c6d9b25edad1019180e762af"
    sha256 cellar: :any_skip_relocation, mojave:        "b663883aabeccfc1f035fbcbe8eb437d97e8c75dd798aa1293155ef9eecf4998"
  end

  depends_on "go" => :build

  def install
    goldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: goldflags), "./cmd/test-reporter"
  end

  test do
    binary = bin/"buildpulse-test-reporter"
    assert_match version.to_s, shell_output("#{binary} --version")

    fake_dir = "im-not-real"
    assert_match "Received args: #{fake_dir}", shell_output("#{binary} submit #{fake_dir}", 1)
  end
end
