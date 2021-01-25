class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.6.4",
      revision: "d77cf03aef82851ab3da0c4c1134673844faaa50"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "4cd065303a7049e57f340029982755755a9f4c0b8c57addc1df96ba64a4a7217" => :big_sur
    sha256 "4cccb3327bbc20e65e5a4e0121bcb3dc5dba7776d61567cc00a239f5bbf6bbc4" => :catalina
    sha256 "53e75e1956ac6d7578453940e46d248f720e81ca71cb961b4b51a2295e9c042d" => :mojave
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
