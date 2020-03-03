class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.102.0.tar.gz"
  sha256 "7e9cb2023d1630903c65f8c5bd9b30e5f71299c0cb5d0f783917c46329ab4ca5"

  bottle do
    cellar :any_skip_relocation
    sha256 "2b69c52970c1c2f4c22df8cd9117130a5aeb839571f173e0a5d1f05eb5038aa1" => :catalina
    sha256 "ec68ddac133d80ce374347c33ff34dd0a156e2fd9056099fde11d707dedb6fba" => :mojave
    sha256 "6147450d21f6c3236dde38128dbf25fbe4c71f427dda0e91514831c50a45c282" => :high_sierra
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
