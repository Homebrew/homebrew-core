class Kubeconform < Formula
  desc "FAST Kubernetes manifests validator, with support for Custom Resources!"
  homepage "https://github.com/yannh/kubeconform"
  url "https://github.com/yannh/kubeconform/archive/v0.6.2.tar.gz"
  sha256 "6da7639bb1cf02375c0a1e2ec5760a18bae086707661f202f56cd8af0f4f5408"
  license "Apache-2.0"
  head "https://github.com/yannh/kubeconform.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79d1f4ade89e12352336bf7f1dd6de34a4f47d5b12a2e6704b1015e10656a3f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79d1f4ade89e12352336bf7f1dd6de34a4f47d5b12a2e6704b1015e10656a3f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79d1f4ade89e12352336bf7f1dd6de34a4f47d5b12a2e6704b1015e10656a3f1"
    sha256 cellar: :any_skip_relocation, ventura:        "97e97c32b1459c56163ba6ff98f44a528ce7fb258b774ab1d128f1731faa26dc"
    sha256 cellar: :any_skip_relocation, monterey:       "97e97c32b1459c56163ba6ff98f44a528ce7fb258b774ab1d128f1731faa26dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "97e97c32b1459c56163ba6ff98f44a528ce7fb258b774ab1d128f1731faa26dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c82e4e7e5a96abcf4acee2cbd50aa96463be66083addfa7e7e7f543e48d00562"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/kubeconform"

    (pkgshare/"examples").install Dir["fixtures/*"]
  end

  test do
    cp_r pkgshare/"examples/.", testpath

    system bin/"kubeconform", testpath/"valid.yaml"
    assert_equal 0, $CHILD_STATUS.exitstatus

    assert_match "ReplicationController bob is invalid",
      shell_output("#{bin}/kubeconform #{testpath}/invalid.yaml", 1)
  end
end
