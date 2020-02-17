class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.100.0.tar.gz"
  sha256 "23abfaaf96defe6a320fd98f34f378357dee969d5a2cf83ac23d59f8fb80878a"

  bottle do
    cellar :any_skip_relocation
    sha256 "4948bfcb5aa1e838ec1d2c55d943d3031ad4b41975baf2f4297b0c78195ec4cb" => :catalina
    sha256 "26cb44dfdecb80cc8165dbe01b1a2e0310d6fba4ddb6e696a8035ed87f39bf28" => :mojave
    sha256 "ce8d76889a0d70590534108e1ed0d917d1d352c0100c3bde229d0e0b7eeead97" => :high_sierra
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
