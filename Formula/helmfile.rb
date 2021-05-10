class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.139.3.tar.gz"
  sha256 "4a07cf28af91cb6f3496e3811fedf78fc3bf5a4f7aba39eb746e1e368354a8b1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ef8d68743267a23ea22dc86cfe7bc58f9c07a217492b18a65fd580a76517e997"
    sha256 cellar: :any_skip_relocation, big_sur:       "2b7345226116fea5fdd97ba32dcf31e48b04828c8e91292003caf6a00a18a1cd"
    sha256 cellar: :any_skip_relocation, catalina:      "e17347d03dc33204263e79e91d96c24f46c241484c01c7540e550caa872d6478"
    sha256 cellar: :any_skip_relocation, mojave:        "ab85c50cd8a16276120285ea7ee5fcbffb6bb1da531547f2b1fb7d76c291525a"
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
      url: https://charts.helm.sh/stable

    releases:
    - name: vault                            # name of this release
      namespace: vault                       # target namespace
      createNamespace: true                  # helm 3.2+ automatically create release namespace (default true)
      labels:                                # Arbitrary key value pairs for filtering releases
        foo: bar
      chart: stable/vault                    # the chart being installed to create this release, referenced by `repository/chart` syntax
      version: ~1.24.1                       # the semver of the chart. range constraint is supported
    EOS
    system Formula["helm"].opt_bin/"helm", "create", "foo"
    output = "Adding repo stable https://charts.helm.sh/stable"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
