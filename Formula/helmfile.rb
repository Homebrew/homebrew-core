class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.92.3.tar.gz"
  sha256 "93263afdd0dda007106dae948418a2ff95d2c4998afe838eeefe94fb62d30abd"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8989644d0bf103551918ab8b4595cfbf019a86d75f08e0671ae560739dc11cd" => :catalina
    sha256 "b5af2e51bb7a7b4268d4b8c8e008d3444a452779c1d0dc2335bf84831fe6a25a" => :mojave
    sha256 "7bda38b2c8ec08b30d42e2295867155ac264344d020d44155ba09453d4fb3284" => :high_sierra
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
