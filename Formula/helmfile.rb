class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.139.9.tar.gz"
  sha256 "81f7f7020542baba308787bd46948e44d974f44172de2b565c99ea24a6a171c9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "62b3054b94851833708156427d140d6912f5839866abef6cb6f5478768fd0af9"
    sha256 cellar: :any_skip_relocation, big_sur:       "6740b599a258886d8c9f1cd552e0d443bf2cd48ade47620ed2e4393c0ed0f876"
    sha256 cellar: :any_skip_relocation, catalina:      "d4a4be4d6092d45df93e82b8be6db4956279c762883b8ce0e7e46d9ccad8be98"
    sha256 cellar: :any_skip_relocation, mojave:        "56ecbed36bf995e8a1e9f4babfbff03b2de3114f3e3e333230b278b83a3dc1ae"
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
