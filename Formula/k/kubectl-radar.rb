class KubectlRadar < Formula
  desc "Missing open-source Kubernetes UI with a built-in MCP server for AI agents"
  homepage "https://radarhq.io"
  url "https://github.com/skyhook-io/radar/archive/refs/tags/v1.21.2.tar.gz"
  sha256 "53b96a3e6929d61e3662f9def215ac1ea74d172f4f7faf40b239d10d5b1e74ed"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "21d560947518ea4663ca14bd5e508c947e62e26a048ce7a841b725e7852ca22f"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e1fe9bc0213c4644a7168fcc86cf2329b319b279960c26c7a27e973b0a40d415"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1e9ae7864cc61bec0ead72599a9d61237c68a83b3aed734b6de9b309c013595c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f0adfc85d13f812e7c2331dbed61fed1f19dd2664e8d4162c9020044eaf53a0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "abfb80a2302e7ec99d8106aee40d258d1900f221ea0ea1e53837f8a3b2a04dda"
    sha256 cellar: :any,                 x86_64_linux:      "a26394c6396b4bf527338f1aeb9c56210ca9164026fecb140578ef10e7250f8c"
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
