class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.101.0.tar.gz"
  sha256 "9e4e9e8c70e16fc1b7a5df14b28f47e4622287282de5d3b6342bc6c4d2487043"

  bottle do
    cellar :any_skip_relocation
    sha256 "507731e6128c12aa8bcb3dec1068304b6a40692a81a34820c4ab29d11bbdda2c" => :catalina
    sha256 "cad92f3689addacab9dc8c200dbc10933fb2e8af82b2b6c54de21b1c27ad0dfa" => :mojave
    sha256 "4ed813e31e4be3234c88e3c81560b991d9c0b0d78b5ee81097fe0bc3012b1d2e" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "helm"

  def install
    system "go", "build", "-ldflags", "-X github.com/roboll/helmfile/pkg/app/version.Version=v#{version}",
             "-o", bin/"helmfile", "-v", "github.com/roboll/helmfile"
  end

  test do
    (testpath/"helmfile.yaml").write <<-EOS
    repositories:
    - name: stable
      url: https://kubernetes-charts.storage.googleapis.com/

    releases:
    - name: test
    EOS
    system Formula["helm"].opt_bin/"helm", "create", "foo"
    output = "Adding repo stable https://kubernetes-charts.storage.googleapis.com"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
