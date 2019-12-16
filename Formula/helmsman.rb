class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
    :tag      => "v1.13.1",
    :revision => "d4731fbe63312934cf7caa6b07acfca6fd2d03c3"

  bottle do
    cellar :any_skip_relocation
    sha256 "5355b3de085c37ac35cc02f7350dd85a212f250e3cc25954489e8c6338b4f7af" => :catalina
    sha256 "b252811d22d8d26c853bb868769fc9618b6c562967f3f045cfbddab53ee1a49e" => :mojave
    sha256 "f54f83dd557ed2b63953719e20ba4ae515887ee465f64444b889322b981621d5" => :high_sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "helm@2"
  depends_on "kubernetes-cli"

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/Praqma/helmsman"
    dir.install buildpath.children

    cd dir do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"helmsman"
      bin.env_script_all_files(libexec/"bin", :PATH => "#{Formula["helm@2"].opt_bin}:$PATH")
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
