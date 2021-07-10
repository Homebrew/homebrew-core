class BuildpulseTestReporter < Formula
  desc "Connect your CI to BuildPulse to detect, track, and rank flaky tests"
  homepage "https://buildpulse.io"
  url "https://github.com/buildpulse/test-reporter/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "0073a9488196abf7fcad2be00f043eeefdb7b1d7d7fc3aa71973b7b4b5d371d0"
  license "MIT"
  head "https://github.com/buildpulse/test-reporter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7de2c4b1dc66b16d46c26a17fc396a36d2dc5358e6060c0fed54f9de5c6136a6"
    sha256 cellar: :any_skip_relocation, big_sur:       "2070ef0470306c32c0543ba5ee7b6e8948dfb34809f6bd241ed30ed74fc4ce9f"
    sha256 cellar: :any_skip_relocation, catalina:      "826cf293e973b133952325e53dc2841ce9120861f4670a891660aefd0e2db11d"
    sha256 cellar: :any_skip_relocation, mojave:        "985a09c3298f1ec7972c5a26295e0d40c12e336ba53dc4d38156287e90165496"
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
