class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.4.2",
      revision: "c08563baf7bafafe3aeb3284cd3410308603cad4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "578c1521ee5191d7ad7af7efba9a67923fa7580ddaa1ec4f35a733b94444acad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d1276b608c2445976ed5103a4a1c7e996cebd142d7c6c4e7d1f59a79f9c7d17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a38bb88490f764a84a98b669f2f46a0e3177aab90ed72000feaadb0f30e55ba8"
    sha256 cellar: :any_skip_relocation, monterey:       "bc4030d81c946ee9e06d7a374690d16d7c56125f0efe287743041afe01d6cd39"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb3bed6cb7fee67c7cb49d3096366ca1833f54cdaa71ce875f277d8f7a4e1fbe"
    sha256 cellar: :any_skip_relocation, catalina:       "12b8fda3d8d8394588dd0bd1a9d822b490a1d228f8ca911a676953a54fa0ddff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b38cd7348313e7be84de3d84c57b9c88c1cdb53d6005aacbb59d50f22dbc7497"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "dist/argo"
    bin.install "dist/argo"

    generate_completions_from_executable(bin/"argo", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match "argo:",
      shell_output("#{bin}/argo version")

    # argo consumes the Kubernetes configuration with the `--kubeconfig` flag
    # Since it is an empty file we expect it to be invalid
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/argo lint --kubeconfig ./kubeconfig ./kubeconfig 2>&1", 1)
  end
end
