class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.45.3.tar.gz"
  sha256 "493bebb74a100d54054f8a9c7f41e34d959bbbd151a267f2aa92535eb00fbea8"

  bottle do
    cellar :any_skip_relocation
    sha256 "c00d6fda8b9a50d477b3d4d111b3aeb4174ae9ffa3b26ee7199495b71776059d" => :mojave
    sha256 "30436dd530c3866c716ae65acf7829b85f510b627bd264cc73ab89af314d6748" => :high_sierra
    sha256 "ea842c578cbfbf6667733f39a5466a99895267a4e595d8b5f147ac62902c0969" => :sierra
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
