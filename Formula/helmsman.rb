class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
    :tag      => "v1.13.0",
    :revision => "eb732a11111e881e5d8918e446f4444acb16a1c1"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e3c363a7f552070ddac2226613bf95b72bcfa73f227c4bf46a675b16208b82c" => :catalina
    sha256 "e07e214524e64fe3aeec6443420c04e942f35bd52f8a713f5ac1f5b7f51dec2f" => :mojave
    sha256 "ea265a6c92c0ab66a593c1b2d972671f4982bd90996e44ab515e7d8edf46dfbf" => :high_sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "kubernetes-cli"
  depends_on "kubernetes-helm"

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/Praqma/helmsman"
    dir.install buildpath.children

    cd dir do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"helmsman"
      prefix.install_metafiles
      pkgshare.install "example.yaml"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/helmsman version")

    output = shell_output("#{bin}/helmsman --apply -f #{pkgshare}/example.yaml 2>&1", 1)
    assert_match "helm diff plugin is not installed", output
  end
end
