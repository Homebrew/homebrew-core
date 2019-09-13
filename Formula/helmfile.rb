class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.84.0.tar.gz"
  sha256 "f34ce50657548a668991f026ca588fff1355bddb515567a6eaa919f9de0e92e1"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec97eca67d198c264fd410bd9e8bcd24e6ad5319906d9bf37427913d88eca314" => :mojave
    sha256 "5d9c848f8b4e501aa68b1152b22d5e4bdcb09cbed403a65df7eadc662ca5f40a" => :high_sierra
    sha256 "f0b5aea5a312add44f21abf853b24196977e61d49fdd1ba85762e2883dd992e1" => :sierra
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
