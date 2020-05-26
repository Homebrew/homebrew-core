class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
    :tag      => "v3.4.2",
    :revision => "469ecf81bcf74c741d0435e41bc109dbcd5a7187"

  bottle do
    cellar :any_skip_relocation
    sha256 "b4b04953992eeab9843762527baa9d2b566b063af13a39f6fb2b591eba9237e0" => :catalina
    sha256 "1124c7a0d90bd82db20ad0a8b5bf8aa4e39f301ab997837c69798b9116bfe722" => :mojave
    sha256 "3ce1b67325d5dc72b2cd1b3fd868d6a74845a56595d17d8c8d80c319e1a17188" => :high_sierra
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
