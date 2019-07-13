class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.80.1.tar.gz"
  sha256 "d64819f7d6f68273e95edb8514a7ac3a9b74bc1e46212f45f3126a9bf19c11e4"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa9ea58e2f181d1dae65a9378b90f4743c9d568c46b5d57296951ec762bb9ff5" => :mojave
    sha256 "eb11d59b2d5e41a137e32f537e3f098b014901da25298318c697bc9a2fc71ca9" => :high_sierra
    sha256 "82250f3b2b6996dc92e720878cea337b6cdb5175e3465bace33a2809be2b405e" => :sierra
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
