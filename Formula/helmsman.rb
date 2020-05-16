class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
    :tag      => "v3.4.1",
    :revision => "9866a4276529ea632064e9d11ae5edfa22942fa9"

  bottle do
    cellar :any_skip_relocation
    sha256 "faad17f4123e3ec57d2effe6a78875e5d180ecdb527dd9ae7d47dd66dc015e34" => :catalina
    sha256 "65885352d287e88fdbd383cda4d7883ce7bce614ed2d9103ae22b56f8832332b" => :mojave
    sha256 "83ce330e540907b05edb8fbd46cfa0d72ade204999133285d87924d3cb84db65" => :high_sierra
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
