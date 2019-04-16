class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.54.2.tar.gz"
  sha256 "ea5c861e6d9f2b2bd4d1c5537d86cc0d9456c003ad2dcae9fd846c9283bcbc2e"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9315f703d49f42b1ececcacef2afd94287db07e4e5054b9b4d4ef40354d69eb" => :mojave
    sha256 "89118b6f3729404260215fefd299d6279480e887b3f83fdced7aa35663c2285c" => :high_sierra
    sha256 "83d317f0d89241c628e3f252c0edab983902a280a49290cdd8c992d3ac8ee0cb" => :sierra
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
