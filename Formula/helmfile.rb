class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.46.2.tar.gz"
  sha256 "5d2d6b0f14fd21d23b7957c76f9f93b4e9e1c12c0abdf6e5627f0034ab83a571"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f8323dce45a8a08f7abd8930701ab8d02491ff8fc8c024da4bbeab0fdc0a0bd" => :mojave
    sha256 "8143209bda191f862d4155773d506ccf7685c57e5805bd9a9082bbd19776db81" => :high_sierra
    sha256 "38db674b44b142ae58fa48bfc01a2fceaf12953d1054504cbcaa65f2bfb818c6" => :sierra
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
