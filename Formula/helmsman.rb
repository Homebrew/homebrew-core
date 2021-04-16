class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.6.7",
      revision: "751b604887b844e001bf78bcde31cb812875d91a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "20aa74928c19928ef2458e9fe5cc5a1e551173504deb83f34af3351165b92c6b"
    sha256 cellar: :any_skip_relocation, big_sur:       "76e4262a28e0cb2e0ebf197e8f6a7082f6e5b5c41dbc2788a588c14f550e74c5"
    sha256 cellar: :any_skip_relocation, catalina:      "e73758e6a646eb43abc9560087ed53bb9d018fce82765396b8c3f2ed490b05d8"
    sha256 cellar: :any_skip_relocation, mojave:        "bee1c42ef4761b0022ec527c7ac586e1a64f5f22e367c10810b6f2a2c5bd3722"
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
    assert_match "helm diff plugin is not installed", output
  end
end
