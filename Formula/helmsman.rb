class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
    :tag      => "v3.4.2",
    :revision => "469ecf81bcf74c741d0435e41bc109dbcd5a7187"

  bottle do
    cellar :any_skip_relocation
    sha256 "cdbc5bbd8bfad6aafda22c165d00060e0d411ec71feb22bc5c7d5aaa09bcbf64" => :catalina
    sha256 "bac1e7bb7aece8be8cee2cc4638a3b4ed9a5d0a275c3d5b19b20d0fd7d5cf4a2" => :mojave
    sha256 "ad81e1fdbf283b1871a4158e1975475d435e9267c0c61bd3f72e6492a70c6ed4" => :high_sierra
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
