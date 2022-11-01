class OdoDev < Formula
  desc "Developer-focused CLI for Kubernetes and OpenShift"
  homepage "https://odo.dev"
  url "https://github.com/redhat-developer/odo.git",
      tag:      "v3.1.0",
      revision: "d02770fa30f3d3e14cff0ff61bd220b42092e375"
  license "Apache-2.0"
  head "https://github.com/redhat-developer/odo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "029a56dc8bf722a2e55e303d0f416408ed5456d20d7957d69144953d38631e40"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35a6cda9b20affc5f14644bf479a39ea6720fd0643281104e4e716c3eb1f6e53"
    sha256 cellar: :any_skip_relocation, monterey:       "97e421a215634d394a299afe1b2da4c1157f4299112b39737134cb43700e3f41"
    sha256 cellar: :any_skip_relocation, big_sur:        "03f3220ebafac589e1df323a1b58e92d1c9e41f87eb235b21f6ab8528b7b9330"
    sha256 cellar: :any_skip_relocation, catalina:       "729e0b98d95d6722596efdf9c24e5ca4e89147632857514e428dad8b8eda36d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dbc34c5e5299e2b95ddc67e2badfa672fc851dd4a73a6dbf606158679edbd00"
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
    assert_match "invalid configuration", dev_output
  end
end
