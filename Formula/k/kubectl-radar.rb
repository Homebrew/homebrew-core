class KubectlRadar < Formula
  desc "Missing open-source Kubernetes UI with a built-in MCP server for AI agents"
  homepage "https://radarhq.io"
  url "https://github.com/skyhook-io/radar/archive/refs/tags/v1.21.5.tar.gz"
  sha256 "231fec25c0fc83821a384148aa39b7f520c6b1acb01fbab9e387c971395c763b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "d30ec7567bb9e3dcac003e7b87d239a92101c695f081cd430fdad46ed81c2a86"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "80cec9fb3258b8ec957f8923ad39eaa8ee586b63f78757b73a9b8eb78fe8fa4c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9ecb25f28215396afbd97cb059a42862ebee40095a0a2bd9dea44c5975a267d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f17b3d6d045d740baf60db4333d42cf7fe1cde8680b461af590364caea7f931c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a32a3e1e7ba8d98904cdd69e343fafc5d166105ddb206a3871ffe53c16d158b8"
    sha256 cellar: :any,                 x86_64_linux:      "a423279ab101a57479e2c33ee8b8c54eabef13527c1143f29a1bea2a5d5cd493"
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
