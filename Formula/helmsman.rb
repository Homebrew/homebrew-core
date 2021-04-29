class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.6.9",
      revision: "773d1b0c519c1c3345256fe3973bde5b78e1ac39"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0ccec13f31f7efd1c43991db2b86547432cb42dbc72d6527f0e9e9d6a2803e1d"
    sha256 cellar: :any_skip_relocation, big_sur:       "35b69718662f1482b37bd1453b103cab614818471796b3e1c4e1eedf95256bc2"
    sha256 cellar: :any_skip_relocation, catalina:      "1c6d2d5b05ce5e673949862c57fdfbbe568d318e5e45dbc352aea8859557e968"
    sha256 cellar: :any_skip_relocation, mojave:        "488083b826d8d51bb29351c9490aa9f68620139239eccc17b816025ca982171d"
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
