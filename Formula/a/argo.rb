class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v4.0.5",
      revision: "0ab1452144d8f4d57c50b37ce50dad218868e950"
  license "Apache-2.0"
  head "https://github.com/argoproj/argo-workflows.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "533c5dd46865b9489b12e53bdcfcd67ff8e4acbea64b38028ff6ff9d3ee044ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51cd286ee48d271cbb34cea8b3b8f8b57bdd74013f012d191ab0269f9750ffa5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c0733a1ede14be473958e2c34680bfba6d21c2d9bc252743ff07cc6a1ad5ae6"
    sha256 cellar: :any_skip_relocation, sonoma:        "0433251965103611161b6c912a6e8576b3afffe7fdda4de27437e777bdad6339"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2594fae39b8786a88b72f08f542f3871aebdab12759ae1fd17f12abc9f096a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2b2ab2ba1eed934e8f00bc504f33e742c6a193fab81ad98279f883ee1297a07"
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
