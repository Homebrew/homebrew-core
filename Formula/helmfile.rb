class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.41.0.tar.gz"
  sha256 "9f06fd4c092abd11c301fac6edf1880d50b5194cbea3da47bda575d367c627bf"

  bottle do
    cellar :any_skip_relocation
    sha256 "f89b4f0ae2ebe7df54f24cc5ac4762704aa40cc3165838150d5d9626a9d7906b" => :mojave
    sha256 "2bf2510a24ba04f750f171317c2cad63da5879d2518343941c3175d9e6b1660a" => :high_sierra
    sha256 "97379d21b8fc081742aa199385b060d57072935fe8abf1ff2fd82718313be27e" => :sierra
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
    output = '"stable" has been added to your repositories'
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos")
  end
end
