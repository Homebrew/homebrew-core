class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.79.3.tar.gz"
  sha256 "d4a0b66d8bfb3af05a2f18a03b170b3184f3c947188c7ee48be1177cca89ae19"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b3a00865a8a9eb8e80a4a8e573e5637c75e3e687d6b31f1775d4f3fdb90958c" => :mojave
    sha256 "4ea4fad803d7c574e7f334b5054f84350907d6dbd1c55b46ab7dd15a2836b8d4" => :high_sierra
    sha256 "85801f15685032dddc574a626eea3e6ded33136e84e88ca01592696461ccb64e" => :sierra
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
