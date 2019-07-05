class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.79.4.tar.gz"
  sha256 "4c44446c8a422c33d3ba45694aa19ac3dd99a80a95bd4aca299d900d1300aa80"

  bottle do
    cellar :any_skip_relocation
    sha256 "28237dee308f3ea357046b75f17b818394e21228b81180cda1089a3c006da461" => :mojave
    sha256 "b4a11d96bc5c570c599b8f3c786741f85adb4e3709c43dcc2c7b7f12d8e0877d" => :high_sierra
    sha256 "6efbebaf8bd3a4fa6de2c0fe532d5f2e83fbc13b6e4c9249f6b5f82de8444d4f" => :sierra
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
