class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
    :tag      => "v1.11.0",
    :revision => "0f5e5f68672e19c095b925949161e2cde3000a24"

  bottle do
    cellar :any_skip_relocation
    sha256 "08a351f79b5e7ea67e673daca37f648348b2578dee25e83c89e42728b07fa033" => :mojave
    sha256 "086a88cc802e3d0278be967e98a9469f723b454b48f753074e4d95bfb8a9b4cb" => :high_sierra
    sha256 "0e359b21ecc7939e7ab1eabf1654d6be4e6df9428354d55902f7c3d78502804c" => :sierra
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
