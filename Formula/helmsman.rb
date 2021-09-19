class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.7.4",
      revision: "679adf3f50dbd74c3721ff5b2c3f1eade9c67913"
  license "MIT"
  head "https://github.com/Praqma/helmsman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "01a8f0d52a2e19d48c7390748f385b39e96072aeeeb8b3ce0d2bd7aeb416237e"
    sha256 cellar: :any_skip_relocation, big_sur:       "31c620d800cb212f9cfe4d3900770d8245f062714a9bdcd6ef4e2f0c169ec1d8"
    sha256 cellar: :any_skip_relocation, catalina:      "34ec03135cdcd6724a3f40120e5996201e672053bc86a19245d0805f922ebc2e"
    sha256 cellar: :any_skip_relocation, mojave:        "c50a7b47bf741503a5598fc1384fd66f2224e88a8210b0a732a35ec9429f71b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7f33241ee43cc916f0d0022bd43ee4bcd2209ad48fff6585edb6efb7510457e"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.version=#{version}", "./cmd/helmsman"
    pkgshare.install "examples/example.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/helmsman version")

    output = shell_output("#{bin}/helmsman --apply -f #{pkgshare}/example.yaml 2>&1", 1)
    assert_match "helm diff not found", output
  end
end
