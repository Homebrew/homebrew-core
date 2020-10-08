class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
    tag:      "v3.4.6",
    revision: "e43f983f52c4d4dad07b56439a8a29dbed35889b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e268fd8463f917ac09ae8dec49393de76ab0d2d947939f1efc51cb90f6e3a239" => :catalina
    sha256 "e1ecb4697f6a4ebeeca791d3b1ed3f114e4e3c9c787cf4ca38df69e427432d64" => :mojave
    sha256 "dab66588b219350e7d49ef1d49234d90f45e1839e2215379f1459b46a01b762a" => :high_sierra
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
