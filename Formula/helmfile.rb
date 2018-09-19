class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.35.0.tar.gz"
  sha256 "b1aac3943ae03e06a248a05f95023d3d4fa02206555741726fddd1d27eaa34ca"

  bottle do
    cellar :any_skip_relocation
    sha256 "6efdb1ed560e076d86c9255e9099639a6c5f1a9625b075ee9dee3d8ee8700f6c" => :mojave
    sha256 "87859c9ce3be93aa602bb1de557ca8eac6d345b6072e5c74abbd5c2c3e288382" => :high_sierra
    sha256 "4d9eda9e1803df3eae36f3bb74e6684772ddf634ddd50b9073bbde8b0a542115" => :sierra
    sha256 "58c159d0dd281d030f8ceea56d6419ccd9e3a8871bdc839f321c685ccd42fb12" => :el_capitan
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
