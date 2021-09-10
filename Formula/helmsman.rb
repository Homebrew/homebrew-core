class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.7.3",
      revision: "2f769b053751d36e0c255a9f0ed369582bc5e0e3"
  license "MIT"
  head "https://github.com/Praqma/helmsman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a865b6c053a2981689752b5c20c4df53448d00d981b643e847d9738eef56aa22"
    sha256 cellar: :any_skip_relocation, big_sur:       "1a1df6c772110a246124ab4c49089fc4d44505c78a193a86f217b911f3d9a9ed"
    sha256 cellar: :any_skip_relocation, catalina:      "3b90b642c183ba3ebb13141b1bf37bed6bc99f767e7c615c3fa43d38f6672c5a"
    sha256 cellar: :any_skip_relocation, mojave:        "d532e2f037b7b9947f99564c88500e9601db8bddc36d837a5b7471deb6723fa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18509f6d26d91d3fede00579cb5ef493ebcf84cc3a6cbef69ff545b71b8ba9cc"
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
