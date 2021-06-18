class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.7.1",
      revision: "4846415ebf12f88894db2401728dbde2014d0edf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e57ecec868fa62dd778e908885e03cd6c32ddc5012cbe0ca77641e98dd0ce54f"
    sha256 cellar: :any_skip_relocation, big_sur:       "498d94fe21d13fd2d8b033013dbfde01a1ec91a9aa096149744ec63e1a606d66"
    sha256 cellar: :any_skip_relocation, catalina:      "05c56c2e6c29a4755e0ecdf54bf674aba8b10d745cc1991a47607520d88deb6a"
    sha256 cellar: :any_skip_relocation, mojave:        "961462a3f1fe9984ea70e1f06fc6e75637efb36d7923fe0f8e37e0c17794f578"
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
