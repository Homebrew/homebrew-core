class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
    :tag      => "v3.2.0",
    :revision => "63a52dc33f99416593758fb2384e150607254885"

  bottle do
    cellar :any_skip_relocation
    sha256 "c59ba9451a5994eef83f2da004b8ae1d5ae44898d13263caead83fb2c07cc9cf" => :catalina
    sha256 "f9f8974d8e3a60bcfedcddf602b379c71c5e13f413ee006e9e278b3ed60bd889" => :mojave
    sha256 "4dfecfa40b9962804a932fabd39da5a5d1b4f04f90a4b508c38b9f003d4e92e4" => :high_sierra
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
