class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.90.5.tar.gz"
  sha256 "da53963d1a8889f85b55d4a7ca290fb997284c6261b5e01f042c6cc854378701"

  bottle do
    cellar :any_skip_relocation
    sha256 "9784796f224193d8c5de511627d4d97d9bedddf78824024c48e647fe61be88a7" => :catalina
    sha256 "0ab49af261abef8e6213ca60fb3cb1521c89a7e1708fd98ea011bc09fea61de6" => :mojave
    sha256 "8533eaf9bfd33f3cf65d0ec8f180e2066e941dc24249a5a1fe2c0746d349c0c1" => :high_sierra
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
    output = "Adding repo stable https://kubernetes-charts.storage.googleapis.com"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
