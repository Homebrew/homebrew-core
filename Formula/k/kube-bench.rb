class KubeBench < Formula
  desc "Checks Kubernetes deployment against security best practices (CIS Benchmark)"
  homepage "https://github.com/aquasecurity/kube-bench"
  url "https://github.com/aquasecurity/kube-bench/archive/refs/tags/v0.10.6.tar.gz"
  sha256 "0b6ba3e7cda64de606a091bbb7a24ed5e5e34c7413ef0574895812a86e868ec7"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/kube-bench.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99c1056199fb24036403acd6de4cc8d24f42206f1c80389e0d56397b2fc201ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99c1056199fb24036403acd6de4cc8d24f42206f1c80389e0d56397b2fc201ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99c1056199fb24036403acd6de4cc8d24f42206f1c80389e0d56397b2fc201ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "446492b022d51ca3c7d57ce81931475b74d57171721df9b4f9934176403ffbeb"
    sha256 cellar: :any_skip_relocation, ventura:       "446492b022d51ca3c7d57ce81931475b74d57171721df9b4f9934176403ffbeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21370ca6054be4c33195271d9b52773536b75e15cca1c9ff55123b05713ba39a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/aquasecurity/kube-bench/cmd.KubeBenchVersion=#{version}")

    generate_completions_from_executable(bin/"kube-bench", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kube-bench version")

    output = shell_output("#{bin}/kube-bench run 2>&1", 1)
    assert_match "error: config file is missing 'version_mapping' section", output
  end
end
