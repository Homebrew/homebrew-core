class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.89.0.tar.gz"
  sha256 "c01617d12148421872ed589b87dd4ef89c7690b190435fa3839bea0e46132729"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ea7089961708136ab65ce11228469e3300372418d7f68492c3a42552a254b0f" => :catalina
    sha256 "f2a59cf85218bc51923a12d2a04cb3d8c93e19cc56328e687638771bbddda03b" => :mojave
    sha256 "a057a814cbacc4a468bc7a9655fd5f0a0c2382c5011395769823d7e9f81f4f2c" => :high_sierra
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
