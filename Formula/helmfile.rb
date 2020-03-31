class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.106.3.tar.gz"
  sha256 "5c76c49b07ba6735d9b0e138d69487e41915e61e231b4b825c5362e05a950461"

  bottle do
    cellar :any_skip_relocation
    sha256 "6fe9aba7f34f61a6f13fa4bdd4071247e1f22db85bb34dea2277c473cb963730" => :catalina
    sha256 "6c8ea1460c7ca7aadac4bfeca84c3ad1665c3385e2de984295bb1fda9630791d" => :mojave
    sha256 "04cb6114da2fbaf80c18c3e72b642ae52f2849ef59ecf805bf88df0750d8d7ce" => :high_sierra
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
