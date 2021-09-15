class BuildpulseTestReporter < Formula
  desc "Connect your CI to BuildPulse to detect, track, and rank flaky tests"
  homepage "https://buildpulse.io"
  url "https://github.com/buildpulse/test-reporter/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "d78d09d68212fbe332f6e7ad5d2c645581d0b8f712e6a0c8feb344b14d3bc785"
  license "MIT"
  head "https://github.com/buildpulse/test-reporter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0cb6602b09e1f55acc92f6bd1a466064bc7a87785ddd22ef8ee0b4db4ff3946e"
    sha256 cellar: :any_skip_relocation, big_sur:       "15b578b8212ee55c591eb2ce13daecd396dfd15d4d13f341dbb3089670e02030"
    sha256 cellar: :any_skip_relocation, catalina:      "84911c146f7a62a4d1044084d540e46926a27a0a5570944f92e34371a9565448"
    sha256 cellar: :any_skip_relocation, mojave:        "fa39de65060f5554e42b68d6807167614ed4981ef4d7eec657df6e38148ba945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a098ea6a0caa562d2ef283605bc9cf4956ddc49409570c8f1f2a828f8093fac"
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
