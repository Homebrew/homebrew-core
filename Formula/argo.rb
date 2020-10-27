class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo.git",
      tag:      "v2.11.6",
      revision: "5eebce9af4409da9de536f189877542dd88692e0"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "4117cb5392f3dc58b7fa127ff5fcaeb094da95302ca4cdfa96e9564c62d0558a" => :catalina
    sha256 "a3c878c148cba9e4853ff56aa9a0994ef79c620ae56364bc438c7c7798c747eb" => :mojave
    sha256 "631cc45b6e65814d64ab5e425c4848efd9a73fada858b068251f52fc0f17c291" => :high_sierra
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
