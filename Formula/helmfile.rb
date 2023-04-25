class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/v0.153.0.tar.gz"
  sha256 "f120a4cf0ea54a6c32d620e825811ff212b1f92a097a4442a7a63b31aaf36076"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c5ddd24c596de1b1456634b114c9f2a6f3cb68b0880c47a46bc4669e6fd85a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc45bfc052e440b2d07198b32d854426cdedff9dfc05d4192de106ec44e13abd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4c8da8c298bce62f30e28229727b3ca97cc53f2192abb8d626de4f3671b74be"
    sha256 cellar: :any_skip_relocation, ventura:        "083ab7f92174d65617658ee0624e9d4b070bcbfa4078a97772d0d1c60bd3d053"
    sha256 cellar: :any_skip_relocation, monterey:       "03f1b4450a2521d6c8167592e0d9f03140ee7e7a5b58b64e57e250e87c85c0f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "0874722cb36f9b857825ea258a96a3b6e07de489ce68b15ac552b47f1a3eb0ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48b8bb833883786f2d163001ea8ef0af5a773278b9be2a9ce7550bd10a55f512"
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
