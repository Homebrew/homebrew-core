class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
    :tag      => "v1.10.0",
    :revision => "59fc4eabf85b2ba54791b5e77f2f450b4fb0c1bb"

  bottle do
    cellar :any_skip_relocation
    sha256 "a6fc8f01511faf89bfc796df2d40931ea2f44c468f6fa18e56f2dca552cba795" => :mojave
    sha256 "c382f8695d831c403a9ba21dbcdcd2674dc12ef0c102ac24c56f33b2d3ebe471" => :high_sierra
    sha256 "8e9f8641bacf5e96ee3ed36e57fc12552d91f1d0e18f5660ecbd671358894d71" => :sierra
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
