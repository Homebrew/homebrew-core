class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
    tag:      "v3.5.1",
    revision: "9bf2a36a8deb659d70c3e5675e197af539aad675"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "64f9a5a163eee2998140a9dddcc8c265ea50e6bfa4101924a036d3af113be3b8" => :catalina
    sha256 "3f49eba19bea3c30af8a962402be5c7f177b5ac119f6e791340f4ac3f060db5b" => :mojave
    sha256 "fba11284df887497b28ed02f4fee6d206d3a13d8a4d8b8f249a7bdf28f7f6e77" => :high_sierra
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
