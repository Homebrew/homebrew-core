class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
    :tag      => "v3.0.2",
    :revision => "1925def1ffeade29c74d8e68ca345e218cf4bf8d"

  bottle do
    cellar :any_skip_relocation
    sha256 "c0faf8b16492e0ad34b9f97aacd87dc6bca51abb95eef29c9db2759c123dc02a" => :catalina
    sha256 "12a28a66f264e799939b1250c0b941b7b56fff250894a1f5826ed207a2d8c9a1" => :mojave
    sha256 "264ec1bbe6b2d0a28aa4ed1369760b3ac9127697f474032243e42de1b14aa253" => :high_sierra
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
