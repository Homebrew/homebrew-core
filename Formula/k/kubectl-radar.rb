class KubectlRadar < Formula
  desc "Missing open-source Kubernetes UI with a built-in MCP server for AI agents"
  homepage "https://radarhq.io"
  url "https://github.com/skyhook-io/radar/archive/refs/tags/v1.21.1.tar.gz"
  sha256 "c5a8a55da42db158ffdb3a6615704ed7267e01b0ababe25a988f3dc11fbb42e2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0a76956a596947e5de9da11cb9580c13a57bad3b8a36871d0ce673b0be451223"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "26142f490490f714160a0d582270c46b3e05f05e39433514303056ee4fa1b6c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c8330ec3814c7b5f9d6b85a90f845f296597e8c0c1dacf4714d7b2487b69a7fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ea629af2d233fccb2aca55b6b85728440596067703f390bdd2c84bb76ca0521f"
    sha256 cellar: :any,                 x86_64_linux:      "08ab9b60eda1021679ee248e144bb0b9f2d7ee71919c020a80c72918b91fa794"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  deny_network_access!

  def fetch
    system "npm", "ci", *std_npm_args(prefix: false)
    system "go", "mod", "download"
  end

  def install
    system "make", "build", "-j1", "VERSION=#{version}"
    bin.install "radar" => "kubectl-radar"
    bin.install_symlink "kubectl-radar" => "radar"
  end

  test do
    assert_equal "radar #{version}", shell_output("#{bin}/kubectl-radar -version").chomp
    assert_match "failed to initialize K8s client",
      shell_output("#{bin}/kubectl-radar 2>&1", 1)
  end
end
