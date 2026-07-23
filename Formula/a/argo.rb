class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v4.0.8",
      revision: "570c470582fc7fe41b1963d8703111679cc3d25a"
  license "Apache-2.0"
  head "https://github.com/argoproj/argo-workflows.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36bad6c59bafc4c8261a01dc81c152c7957af1e1d2046a0fb35ba950fc2aa956"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aaaf5f37bcb5eff4dc129df801e54b6d7c15b0c02ce9b731644a03750c10c011"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f261ed79375def9f643585ebd36885c5ed7c8c1586082bc951809e72fae655f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f7605d0518eda310f76e5284c3118b753a03ea9c7c7fa79bdc62e82fea4d648"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "222219626286f51b2339c38512b31bbed9f29dc6cae459b231a0286fc303d238"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18ee342b027ed3bc93017161f756e4afad7401acbacff4cfa4d6136cc9422b7e"
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
