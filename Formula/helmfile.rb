class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.43.2.tar.gz"
  sha256 "b9ce3ce1e8bfa258004c9ddea21b3c9a27f27d40835517da3f716305e099401a"

  bottle do
    cellar :any_skip_relocation
    sha256 "bae701ab9d55bddf353b555c69045521e6c064e9183fb1a5a18ddef6cf91a9da" => :mojave
    sha256 "21308fb2eb1241c2e6ac28209f2c2a9e77684afd4255462774555284e5358b87" => :high_sierra
    sha256 "5dbf6d150ab7d5ad5333df1f4e03e352a0d0d047f1b0c3e7e90bd185167f04b6" => :sierra
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
