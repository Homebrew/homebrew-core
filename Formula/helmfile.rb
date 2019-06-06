class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.73.1.tar.gz"
  sha256 "79d66bdb00da931060d4994c6d7180dc5c4e0d2d06b8a654b2c183f4eaf51705"

  bottle do
    cellar :any_skip_relocation
    sha256 "df5076897d782a8138bdc26b9c84d9b95b7ede35768281aeb5c0631fe9f4023f" => :mojave
    sha256 "b9897adec1c1c194082ad77ddba8e77305bc13685951c8cb63cb65c81fd91c50" => :high_sierra
    sha256 "cc1345cfb18ea54d1623df3607840de77bc2952ac4a5115918fb83e3025a526d" => :sierra
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
