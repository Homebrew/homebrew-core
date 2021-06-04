class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.7.0",
      revision: "995800328cf48b13ccf19f3d459767db269e3823"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cfd2ab562ab5bc6304d3f82655f93875fdfe3bc6c3cb235f8b5c13ddc9ebbc2d"
    sha256 cellar: :any_skip_relocation, big_sur:       "1e4db69c004603804cb86347a0c9fb86fc83c6ea1c6c6751bd66dd03ea961571"
    sha256 cellar: :any_skip_relocation, catalina:      "12a5f4a4a8489c4b931092beceabb9ecae2927c9a43483f9f7f7dd10e850adf0"
    sha256 cellar: :any_skip_relocation, mojave:        "bf2c4fe81938188969df95a39645881e509c7768171808786bcc89e039386a67"
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
