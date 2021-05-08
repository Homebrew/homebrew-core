class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.139.1.tar.gz"
  sha256 "d5c9c8ba48b38bd44cec9702f4cac73f070c856a69cc9a4ef432e5fa9d41ef53"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3a9f5f6f5cde95bb345870d61f0d6537a1359ba88af8b429a5a08b60c34f55f0"
    sha256 cellar: :any_skip_relocation, big_sur:       "7292c11a559caa8f8d68d5b7f7975e056f4eac9923b6f6aecaa86c7478c4dff5"
    sha256 cellar: :any_skip_relocation, catalina:      "36bd7e563dd68c48dcb9b72a09b18cccf2056a25043c5c363599bfd034700b8f"
    sha256 cellar: :any_skip_relocation, mojave:        "31e47afcfe4787fc1c46f204d8a82a2416128e4add520b559a5c6bed25d8aa37"
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
