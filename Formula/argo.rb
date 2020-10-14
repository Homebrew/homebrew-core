class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo.git",
      tag:      "v2.11.4",
      revision: "571bff1fe4ad7e6610ad04d9a048091b1e453c5a"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e2d13d6d89fe573dc06249bc8881385f0c9eb684051ea27dbdba161761d3035" => :catalina
    sha256 "a39f5975e285170f9b43f0d9832eb07aeadb9c4678e2f9af46c1c6dad4f8d2b2" => :mojave
    sha256 "14cc88a9ccc3584af8477eac59245897e1494ba06f27c8add7292d4a99736013" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "dist/argo"
    bin.install "dist/argo"

    output = Utils.safe_popen_read("#{bin}/argo", "completion", "bash")
    (bash_completion/"argo").write output
    output = Utils.safe_popen_read("#{bin}/argo", "completion", "zsh")
    (zsh_completion/"_argo").write output
  end

  test do
    assert_match "argo is the command line interface to Argo",
      shell_output("#{bin}/argo --help")

    # argo consumes the Kubernetes configuration with the `--kubeconfig` flag
    # Since it is an empty file we expect it to be invalid
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/argo lint --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
