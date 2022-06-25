class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.3.8",
      revision: "621b0d1a8e09634666ebe403ee7b8fc29db1dc4e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0049dbfcef582d0d24d28d4f837cd3f977f79c3b49a88558feaa5ed11862c574"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff5a9ab912896f0e8899d2bb1d3bcd875a474444b9843e863b3121c5abb65850"
    sha256 cellar: :any_skip_relocation, monterey:       "5dbcf14094279e592af85b32764b0fecb09d4a4e1903be722d32f4b1c11db758"
    sha256 cellar: :any_skip_relocation, big_sur:        "443851c118091c72b400ff940daf99ae0fbdb8dc400b2852e499f1519c0c9ab6"
    sha256 cellar: :any_skip_relocation, catalina:       "958e818fdd4b8a97b024559e5ee3fbe3b955555e0d5a60cca92d55df33b8a642"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6f2fb164bf3d1a01479539df377f9c7e8540d7ec8f1570fc406fb73ba04fddd"
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
    assert_match "argo:",
      shell_output("#{bin}/argo version")

    # argo consumes the Kubernetes configuration with the `--kubeconfig` flag
    # Since it is an empty file we expect it to be invalid
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/argo lint --kubeconfig ./kubeconfig ./kubeconfig 2>&1", 1)
  end
end
