class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.77.0.tar.gz"
  sha256 "55cb9a3da43a6916fd4d172fbfd752a688ca2df0867733286911f147f9cfc096"

  bottle do
    cellar :any_skip_relocation
    sha256 "955f11ec44932f86688b022f38fa1099444198678febe453ff364053775c9498" => :mojave
    sha256 "b0745ccea5b9558df3b15394adca809b7496c28a7b8996d514767ca3f240ff80" => :high_sierra
    sha256 "ad45519c6a4bbae34020e3dcf706d00b763aa815905f96f3b5c74faf49da17ee" => :sierra
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
