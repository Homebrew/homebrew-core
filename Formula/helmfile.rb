class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.45.2.tar.gz"
  sha256 "a912e26e6a2fc09b3fec862319831b2437373860c4bf77508928b22ceee46492"

  bottle do
    cellar :any_skip_relocation
    sha256 "23ba5b18bc93fc698e2d4af7308d5bb10a6a467039019510407f4ba6c707e866" => :mojave
    sha256 "e28986c7ea6fbde33b36773e54b3b535fd6532fc627ca8e38086daedc6b009e9" => :high_sierra
    sha256 "bd233af84878f4860edd94b6fac267cff588f3a46006535682ff2467cf95f73d" => :sierra
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
