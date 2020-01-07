class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
    :tag      => "v3.0.0",
    :revision => "b38d571bca31699eedc3fb0a199f9f2b657870fb"

  bottle do
    cellar :any_skip_relocation
    sha256 "5355b3de085c37ac35cc02f7350dd85a212f250e3cc25954489e8c6338b4f7af" => :catalina
    sha256 "b252811d22d8d26c853bb868769fc9618b6c562967f3f045cfbddab53ee1a49e" => :mojave
    sha256 "f54f83dd557ed2b63953719e20ba4ae515887ee465f64444b889322b981621d5" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    system "go", "build",
      "-ldflags", "-s -w -X main.version=#{version}",
      "-trimpath", "-o", bin/"helmsman", "cmd/helmsman/main.go"
    prefix.install_metafiles
    pkgshare.install "examples/example.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/helmsman version")

    output = shell_output("#{bin}/helmsman --apply -f #{pkgshare}/example.yaml 2>&1", 1)
    assert_match "helm diff plugin is not installed", output
  end
end
