class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
    :tag      => "v3.0.0",
    :revision => "b38d571bca31699eedc3fb0a199f9f2b657870fb"

  bottle do
    cellar :any_skip_relocation
    sha256 "01fc874d50dee266d2cec5491bdc4eb6708974fd52215f0e7b39b95091a8e616" => :catalina
    sha256 "75aeb08e919561779725e565337c73cdd2246476cbb9406ed4a043d59a304ff4" => :mojave
    sha256 "b8481b0793fa3492dcc35236eaeb0d0295caa97960c358e92c94a5ba9ecf94e5" => :high_sierra
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
