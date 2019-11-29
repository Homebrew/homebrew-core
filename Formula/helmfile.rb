class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.94.0.tar.gz"
  sha256 "f426b8d5631a3cb2c62abe062355a07075e788923c417bb044b0ed7708e3a801"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7f8bcae48fd24c7d0d516467c9f0b2d1ac88a61f49c444d1eca203140413e53" => :catalina
    sha256 "147a73e75c1899aab88b4a75e1245d72a6f3aff5c91d8f1c3ba348e6c4fe2480" => :mojave
    sha256 "519c845dcc7f7eb536f08da64be1eeb98df4239c6234b1451b68f646c70bfefe" => :high_sierra
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
