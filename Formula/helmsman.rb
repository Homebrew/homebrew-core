class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
    :tag      => "v1.10.0",
    :revision => "59fc4eabf85b2ba54791b5e77f2f450b4fb0c1bb"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a22f3dfed4d52cfa26b1cecc814a914597eb05dbcc944d388c2861ec00a5cce" => :mojave
    sha256 "39091e7f5e4e2b98da49231c3d05e562e942110aff03b3a2ca189d752527d175" => :high_sierra
    sha256 "26c49e55b814717ac8c2ecb0dbaa4f44cf6590644dd9a0621f5e714e4d33a645" => :sierra
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
