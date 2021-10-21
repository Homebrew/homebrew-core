class BuildpulseTestReporter < Formula
  desc "Connect your CI to BuildPulse to detect, track, and rank flaky tests"
  homepage "https://buildpulse.io"
  url "https://github.com/buildpulse/test-reporter/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "ead1db68b7826eeb302cebf0bdacd25b835b896b43883b57c94a74c0d96fd0cd"
  license "MIT"
  head "https://github.com/buildpulse/test-reporter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0e0870837a12a3e1165102bac9313166b9b975f18838c4d1382fe84178103663"
    sha256 cellar: :any_skip_relocation, big_sur:       "63e7bbd72d62203b1f9c52181321c013d62d0f923935b8a73ea963667f91dbb4"
    sha256 cellar: :any_skip_relocation, catalina:      "e9d1b748e89b1499221e6b9568385216aea66c368b047a24e5595c10fab1d7e3"
    sha256 cellar: :any_skip_relocation, mojave:        "520d4afa812b340c2475245fb1b17349aca8bbb81692cfe15a1e74dadf7bfafd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fd17552ff2c625d62de2361a011de4703f794a8abcbb1c466a408b607bd18c4"
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
