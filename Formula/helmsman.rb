class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.14.0",
      revision: "ac34dfe2afd8ce26618c1f297d29d79a9641263b"
  license "MIT"
  head "https://github.com/Praqma/helmsman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02b74c946c3442c73f7bb913e212a8f155de47e28f70eb8f54234d41d16d6c8f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2703398f5d9e0c02e169b3777f1ebb0f011b7a27b4d7e58a5e8ff301657a15d"
    sha256 cellar: :any_skip_relocation, monterey:       "072ec442bc3a16542d78543ea25632c17ae0ba850997bdaed9fc883aee70381c"
    sha256 cellar: :any_skip_relocation, big_sur:        "09bfd33a5e1bc90044894f09010b945eba4bed43cb5f2a973d96cfa71a7c2c0c"
    sha256 cellar: :any_skip_relocation, catalina:       "d043b6c1d86943033d5ac4d2870b789fce980c9be200d7e67c1386977a71930a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18da6709c3b3032286550dba6b95c83b84342a2efbeac559ec2caeadc3a86904"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/helmsman"
    pkgshare.install "examples/example.yaml"
    pkgshare.install "examples/job.yaml"
  end

  test do
    ENV["ORG_PATH"] = "brewtest"
    ENV["VALUE"] = "brewtest"

    output = shell_output("#{bin}/helmsman --apply -f #{pkgshare}/example.yaml 2>&1", 1)
    assert_match "helm diff not found", output

    assert_match version.to_s, shell_output("#{bin}/helmsman version")
  end
end
