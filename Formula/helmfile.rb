class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.73.2.tar.gz"
  sha256 "917aa167de4e560a318738c44498be48b989395770dab21d6a4369ec6945902b"

  bottle do
    cellar :any_skip_relocation
    sha256 "1fd01f2c9583819e4dcb3999a494496739b604db58cc49c595ce1a93cfe5555a" => :mojave
    sha256 "c6634741768708fbefafc09a30d53b17bdc7ca13fa93e605bdb27f8bba162d04" => :high_sierra
    sha256 "8102bd870f131cfe7583735a1b9403458971aa762386ceb414754f6b26adec34" => :sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-helm"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

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
