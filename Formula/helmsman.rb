class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
    :tag      => "v1.12.0",
    :revision => "6b62ea3941dc9be9cfb9eed457074152f809405e"

  bottle do
    cellar :any_skip_relocation
    sha256 "84542045562e7ca2298f811f38c9b86d038816720ca3c2a551da03f5fee3e3b0" => :mojave
    sha256 "05fd133dec4b9d900d9d5d8254d0fbc2803c11a61b818a427c7ee140bb0eb7cc" => :high_sierra
    sha256 "e044eecff4c7624bdc9623fa4d35ca15b6907da688c5c6b6f6f62318d3b3aef7" => :sierra
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
