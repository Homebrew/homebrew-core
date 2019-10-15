class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
    :tag      => "v1.12.0",
    :revision => "6b62ea3941dc9be9cfb9eed457074152f809405e"

  bottle do
    cellar :any_skip_relocation
    sha256 "0bea12f035c1fe0f7c849bdab3415c25f62759945dcd85e35bb019721714ceea" => :catalina
    sha256 "c48c7f7263f4888c70fd01050b09c1353fc3ec9ff94d890a1b91201ff7fd2dd7" => :mojave
    sha256 "12c21c1446a0c7664d7e184463d1507880a6118d89019fa0d3523e3dc52aece1" => :high_sierra
    sha256 "0712878d28acc0efc4ef596801cc5a378712fd22007bf4d6592cef9687573e3c" => :sierra
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
