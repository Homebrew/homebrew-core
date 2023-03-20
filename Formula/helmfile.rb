class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/v0.151.0.tar.gz"
  sha256 "3f6c872c85ece40fc063db2448a9fe970bc58852aa5e0199fe1e9d523c9a3556"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "656927b705c99974a92853a07fc14e273cf7a2d2a4586f0fac8294dce39ca99f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "375f90b7e7382d61f74fdf39b1bedd5da79c3b4850bce7e951b40f7ff95b8d9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc9546b35d0dcff4624aa5468a9443274d1e6d3efe99d7228b05536aa80b199a"
    sha256 cellar: :any_skip_relocation, ventura:        "6d8fb98fd64151f2c09e12ad31666053b3b4e5fc29cc230ab70800763102eac4"
    sha256 cellar: :any_skip_relocation, monterey:       "78f4e74cf9fd7a7c247899753a313960a0ae042fc1ebdc7868d40fe348e2e34d"
    sha256 cellar: :any_skip_relocation, big_sur:        "efcc426b534c22c9d58535cdbd463f1d8807ec1fea879ecb066d7a1169f5ce52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98bc49b933b3e1c2f7bdf1200fc93a745d6e45a252f018b3e32faf954396e919"
  end

  depends_on "go" => :build
  depends_on "helm"

  def install
    ldflags = %W[
      -s -w
      -X go.szostok.io/version.version=v#{version}
      -X go.szostok.io/version.buildDate=#{time.iso8601}
      -X go.szostok.io/version.commit="brew"
      -X go.szostok.io/version.commitDate=#{time.iso8601}
      -X go.szostok.io/version.dirtyBuild=false
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"helmfile", "completion")
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
