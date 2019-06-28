class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.79.3.tar.gz"
  sha256 "d4a0b66d8bfb3af05a2f18a03b170b3184f3c947188c7ee48be1177cca89ae19"

  bottle do
    cellar :any_skip_relocation
    sha256 "c9870c61df8a5340092aa09a123a94d8b736549753130a82f0f8abff1cbfe0db" => :mojave
    sha256 "7a8e13962c45a01ee31ead880390b8cd78a729ee4897575af825f1767cdfdd0f" => :high_sierra
    sha256 "2a4edc0427590f1d9922c5c76fff4e61a667f576a0a3fbad4994e0532d3a5910" => :sierra
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
