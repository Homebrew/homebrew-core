class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.77.0.tar.gz"
  sha256 "55cb9a3da43a6916fd4d172fbfd752a688ca2df0867733286911f147f9cfc096"

  bottle do
    cellar :any_skip_relocation
    sha256 "7af065ce030ce70dcabc33afb0a6944a0cfe8c62878ae203945df14c1c9bec1f" => :mojave
    sha256 "6ee3226c63a5dc9bc2ddc0a9214f68112884178236ad683e0666175b0f8d319e" => :high_sierra
    sha256 "563b261c34df528c33e6fd607f3a67bfca1f768a800f677b7d64c7a2773454b3" => :sierra
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
