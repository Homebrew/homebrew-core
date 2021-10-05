class BuildpulseTestReporter < Formula
  desc "Connect your CI to BuildPulse to detect, track, and rank flaky tests"
  homepage "https://buildpulse.io"
  url "https://github.com/buildpulse/test-reporter/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "290850414bd956446ca48cd26117ad2bed32dd9623af5240018cd66321944caf"
  license "MIT"
  head "https://github.com/buildpulse/test-reporter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "695bde4c506aa392a6035a6e87146ca3c75301e079d774ca2eaae0c22d988547"
    sha256 cellar: :any_skip_relocation, big_sur:       "bb1a83790bed10de69a10d3e4e1f926aee892ede1e7850770709b329b2700870"
    sha256 cellar: :any_skip_relocation, catalina:      "73ddb901359e2f0f79e06864d73cc34c98fb3a76df4df44aceb439d2d5d7d583"
    sha256 cellar: :any_skip_relocation, mojave:        "16db9b100b32060e51a19f089fcd005749af5bca7a4414ca1624aa5c51994c8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd29f8c2ce6943fe4564632b462384a9b0b57ec1d665b44a7c3aadeb7b108dfb"
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
