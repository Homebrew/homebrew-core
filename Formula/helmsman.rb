class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
    tag:      "v3.6.2",
    revision: "7bfad8d3a80385bab4186b82a50b724f16dcbb24"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "147c3374588210660b3e6343c95a5fb9f901b310544ed210afcf73576283f6b6" => :big_sur
    sha256 "dbe22c308c8de99794f88803d990c5df5c1b76e79570ff82c7cb712900ce101c" => :catalina
    sha256 "237bf255f83389268df66a08d11292e1048cd4cb2b696c3181d47286089cfe2d" => :mojave
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
