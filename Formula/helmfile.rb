class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.78.0.tar.gz"
  sha256 "e39c10f80769b5ae79f8c0ddb5e749bcb86badc299d10fd59c4778ecc795e8ca"

  bottle do
    cellar :any_skip_relocation
    sha256 "9edf52ba092c4013a566b80fff0e0d41468e41be66a854be20c5c669295a6047" => :mojave
    sha256 "c83b5c2ecd315b5bdb328689ce214af9fc8cef99d315af83ce5a8f03fa936075" => :high_sierra
    sha256 "ed24beec689feca39a655d0ccbfe296c15df6b6f4f6a5d70f1b6553cffa1c4f3" => :sierra
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
