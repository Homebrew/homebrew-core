class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.85.1.tar.gz"
  sha256 "ba8573a0f5e507933140de4842059a847b1bf2014f2fc89bd42508c54691688f"

  bottle do
    cellar :any_skip_relocation
    sha256 "502c35abbecce142a4208a61ea20fe4ac35248d124df4630ba599e70f87ef3ca" => :mojave
    sha256 "a2f2e58e8367330eec3aaf186b78aaa8fbe7eced0a450cf656af682d44588494" => :high_sierra
    sha256 "5ca19ad506e34a5b5790af862730f001223f8efd9ede548ffaeaca49644a2cd3" => :sierra
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
