class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
    tag:      "v3.6.1",
    revision: "2764e44cd6b78b2405c17cf741ed4599771b47ec"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "5757c987e73c1837a434afb7a96497345a49dd01250d62732e1af5b683ed1c81" => :big_sur
    sha256 "27b251021a112c20015ace659603ee0bd160feeab14d8f0fe7506c316f063918" => :catalina
    sha256 "3cb90a34ac154be7d83fc1f42cad3918c769d3a21362884ea955f49b4ed2f1a3" => :mojave
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
