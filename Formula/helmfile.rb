class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.94.1.tar.gz"
  sha256 "aff89609be5b0c88dfa7d2212b0f143b23ce137561bfe2c1a705419f91d9f0bd"

  bottle do
    cellar :any_skip_relocation
    sha256 "582cd9fbcd2f20ecc7eb8d7d6e02a3d524cf6d54acd3abcacb413b6aa3b2667f" => :catalina
    sha256 "047c59bf5b1f610460963e90f2f7644c7e0177b64862b8abdc365cc4df31580c" => :mojave
    sha256 "151c3f0ff19575a3475f9f68a8123c101367ec3cea2e6c4a5711c758ef6e8f3b" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "helm"

  def install
    system "go", "build", "-ldflags", "-X main.Version=v#{version}",
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
