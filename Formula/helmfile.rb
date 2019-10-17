class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.87.0.tar.gz"
  sha256 "883461d6c2513cf2da06dd74aa2a0ec059830d2c8a9981840dc0ea2ca2e8de0a"

  bottle do
    cellar :any_skip_relocation
    sha256 "afe30d1f65520d27c3fdfafbc7bc2529de88d2a19610ecb677a05805fc55a81c" => :catalina
    sha256 "dbe0bbfc4be6bd11f01dc12e4a935aad0347b926a831f2d09e8b24821dcbd98a" => :mojave
    sha256 "ebe509cd9d8ce643af77199405d9c501414d71a7187af9597937b9178d6aa320" => :high_sierra
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
