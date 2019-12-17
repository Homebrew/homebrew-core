class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.97.0.tar.gz"
  sha256 "34ebe9b78aa46b52a5efae612760c1b392f5ed241f2fe13edf6396ca021ce13f"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ac2e85271f9d383f4a972df7bcbda3f4461aaa9cfe9e557cf77e2aa507c85ef" => :catalina
    sha256 "4f89e25e74cbe696b5a272efcdb1ab09b010e7407eb341f04cf5d53d5e2e7c62" => :mojave
    sha256 "083fd0ca72ae41fd4d1bd52dc3b352aa92b9543ffc31a353624073a95838484d" => :high_sierra
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
