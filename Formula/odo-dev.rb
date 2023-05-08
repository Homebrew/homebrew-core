class OdoDev < Formula
  desc "Developer-focused CLI for Kubernetes and OpenShift"
  homepage "https://odo.dev"
  url "https://github.com/redhat-developer/odo.git",
      tag:      "v3.10.0",
      revision: "039ef07320e8dce076223fa10949b96648e1de15"
  license "Apache-2.0"
  head "https://github.com/redhat-developer/odo.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8069eca8eb10e735d3ee60b6c53fd48e6ab10cd51904a00b8c7ceecc7075ab4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "786ebf459192bf4d838eea4c35dd1aa08a3e35344f3ab5d9fddf32c6625f43fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14bfaa1d2a48922d4fbe9663f06c2d3c25741244bbf1ea5ca7d0e09b08b3d460"
    sha256 cellar: :any_skip_relocation, ventura:        "a61962dcd688643736b52d5738b7ca2ca0ee8c0bc1d241be5a4ce01ae897e8ab"
    sha256 cellar: :any_skip_relocation, monterey:       "cde011422562ee124814f91af78dae1c5aa6f6ff35153556d816532dd05cd511"
    sha256 cellar: :any_skip_relocation, big_sur:        "97e4fcc1f624269c98c6c6a192221eb4c07459309c2c350d2d5cd9ae0c950314"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f78fefab32560d6c39a4af3e4e45f36246e0e37fbd58849473ae46a2d24c4c2f"
  end

  depends_on "go" => :build
  conflicts_with "odo", because: "odo also ships 'odo' binary"

  def install
    system "make", "bin"
    bin.install "odo"
  end

  test do
    # try set preference
    ENV["GLOBALODOCONFIG"] = "#{testpath}/preference.yaml"
    system bin/"odo", "preference", "set", "ConsentTelemetry", "false"
    system bin/"odo", "preference", "add", "registry", "StagingRegistry", "https://registry.stage.devfile.io"
    assert_predicate testpath/"preference.yaml", :exist?

    # test version
    version_output = shell_output("#{bin}/odo version --client 2>&1").strip
    assert_match(/odo v#{version} \([a-f0-9]{9}\)/, version_output)

    # try to create a new component
    system bin/"odo", "init", "--devfile", "nodejs", "--name", "test", "--devfile-registry", "StagingRegistry"
    assert_predicate testpath/"devfile.yaml", :exist?

    dev_output = shell_output("#{bin}/odo dev 2>&1", 1).strip
    assert_match "✗  unable to access the cluster", dev_output
  end
end
