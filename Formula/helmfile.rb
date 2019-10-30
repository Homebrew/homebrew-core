class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.90.1.tar.gz"
  sha256 "781b53eec72856cb94f14b015ad6b565170f9b77c4e1823b1ded645e48ea1538"

  bottle do
    cellar :any_skip_relocation
    sha256 "8bae474c35b6a6d94e17d29786c9a3bea905af06c37705ea266bc92d8f0b77db" => :catalina
    sha256 "ba7735b69628c02b8830741ff11029cd096fa33ab1102f0bbc9043649ba1fd2c" => :mojave
    sha256 "6ab438be741d33de1f99682238d0788cfe07450ea85c337d1c6d146cc50bd38b" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-helm"

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/roboll/helmfile").install buildpath.children
    cd "src/github.com/roboll/helmfile" do
      system "go", "build", "-ldflags", "-X main.Version=v#{version}",
             "-o", bin/"helmfile", "-v", "github.com/roboll/helmfile"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"helmfile.yaml").write <<-EOS
    repositories:
    - name: stable
      url: https://kubernetes-charts.storage.googleapis.com/

    releases:
    - name: test
    EOS
    system Formula["kubernetes-helm"].opt_bin/"helm", "init", "--client-only"
    output = "Adding repo stable https://kubernetes-charts.storage.googleapis.com"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
