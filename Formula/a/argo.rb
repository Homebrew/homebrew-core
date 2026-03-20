class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v4.0.3",
      revision: "8cae17b6fb49f077eeb269fcf21ce021b37a97f1"
  license "Apache-2.0"
  head "https://github.com/argoproj/argo-workflows.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c1b5d90fe75faa997ad8ba8533ce9064f1cb5a8f229a32b2e67342c1490a72e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e70ff0905fdc7fa5e35a84c04cfcf39c682649f94a56498fc72764af951802e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54c3c0ed1be56a742542978e34a8f963fea729077320686be1aa85d83a4e3a7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b543e43ed39b3a5fd75aa92c9b2844e5715780b1af51a64835d0c4187973fb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f5b355c0dc5d5ab07214e2d275b05da1e2635682b95644f72d626b3319bc707"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1213bffde2384805a185d5e33a4fe6c5eb37f875698568e30fabf51f5f1400cc"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "dist/argo", "-j1"
    bin.install "dist/argo"

    generate_completions_from_executable(bin/"argo", "completion")
  end

  test do
    assert_match "argo: v#{version}", shell_output("#{bin}/argo version")

    # argo consumes the Kubernetes configuration with the `--kubeconfig` flag
    # Since it is an empty file we expect it to be invalid
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/argo lint --kubeconfig ./kubeconfig ./kubeconfig 2>&1", 1)
  end
end
