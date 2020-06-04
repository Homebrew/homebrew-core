class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
    :tag      => "v3.4.3",
    :revision => "f785a59170f89560ef4f943e1b665ef5337f3c54"

  bottle do
    cellar :any_skip_relocation
    sha256 "c5289b7b2c1497fb89fe8023c60b590bcf34be34aae6c86ce3608d632e0bb187" => :catalina
    sha256 "0eedf68858bdaa60ea1ec582997154a5d97d55ad00a26122b3690c6c97467468" => :mojave
    sha256 "fa72959a8e8bf178a35a79b89b0d176ee76ccb686fa4bebd9183dad276b5bc6a" => :high_sierra
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
