class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo.git",
      tag:      "v2.10.2",
      revision: "ed79a5401162db7a3060111aff1b0fae5e8c2117"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2992d27e2888f34d7c035112508106f437e04bbbe7178d34f8a9908adbd4106" => :catalina
    sha256 "1ff5a9cc742fe9e657e8e2e67337ffcf3d8f083af8a2d45b5fde459859cea281" => :mojave
    sha256 "d7febd066562584d6ccb69971a5071adce894c5df10f331212ee84ae682b5fda" => :high_sierra
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
