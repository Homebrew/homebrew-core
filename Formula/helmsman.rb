class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.6.10",
      revision: "fc2dc7832689544a6ea0e9242f0adbe7543c1ebd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ea86fa8138118dacfbf65a97fbc58fa126e8fb2c3b44464b9bf625c2dc543f7e"
    sha256 cellar: :any_skip_relocation, big_sur:       "4f4fe4081da0c03f99ebd8c2a1f7ac78f2edf4f17e54ff9c45e04d7a822d6da9"
    sha256 cellar: :any_skip_relocation, catalina:      "bebf2de10998de4fc09301c2b34b2c52ef758da496152ed00361d404ef511f87"
    sha256 cellar: :any_skip_relocation, mojave:        "19d57e12783dbcae3107942e13449caf0e8f0abb65d50d2cdc1f65dec2f6c66a"
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
