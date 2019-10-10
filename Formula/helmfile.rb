class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.86.1.tar.gz"
  sha256 "09ca9a76ab1287a0bc905d5a6ef7170947a873ca5c111d94925931b983b4069a"

  bottle do
    cellar :any_skip_relocation
    sha256 "73df13350a689ab8da6ab62a41976a1719cff5b616b12a103bd2964e77cf9f7d" => :catalina
    sha256 "e1aa10b922497c17ba63f6bb98c68e7a2ae98b03ef3fb6e0d3cf37533eaa41d6" => :mojave
    sha256 "d720904a0ed008f2564351a6406f7b2e77a7e718c7b11581277933ecdf036d37" => :high_sierra
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
