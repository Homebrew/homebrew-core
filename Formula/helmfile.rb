class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.85.0.tar.gz"
  sha256 "d07e2df11507739aafbe90a10a96a648be24c46c2abe5713c8e4dad150d839ae"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e444f960fc92807c7da5b209d5252e081a9d185d8c3e23bdff3993d9e855c66" => :mojave
    sha256 "85551cf2551284a1f73bcdb853dc01009ea5474146ee760ccdfb9a201d6e39d6" => :high_sierra
    sha256 "fc653674b6da259c67a13ff4038534919bbbeffb130d0802579abe4f5ff068a9" => :sierra
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
