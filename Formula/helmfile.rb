class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.100.1.tar.gz"
  sha256 "25722bad9bc566541cc6afb6ac50bfaa3883c8354680e518c679219a174fbd8b"

  bottle do
    cellar :any_skip_relocation
    sha256 "32ca1603992633a389c577a3b05bfee17150465835db355a91cea0809784f305" => :catalina
    sha256 "ebb372bd125b51a032c7222ba302a1913b3ee55d028667e962c9ef9872a3e3e0" => :mojave
    sha256 "4a7a64ad2e6badc7f093b23d070de4fe57f32acd9d13a30c6e9701fadc3431a9" => :high_sierra
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
