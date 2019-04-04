class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.53.3.tar.gz"
  sha256 "a75878550405052bc50d2968f13605ac7e7a9d9b487c6db0ec709c190c21c93f"

  bottle do
    cellar :any_skip_relocation
    sha256 "49819cc2efb5c183be8f4cbdf468523181f3075df6c12987fe8621eedc3d2315" => :mojave
    sha256 "b824d915babab1c16d9ce141a06700b3d0758176958cb0a80940b7a84632b735" => :high_sierra
    sha256 "07c40fdb920d6d657b734099ad193575df1fe125cbf1c60b73302c62b59d801d" => :sierra
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
