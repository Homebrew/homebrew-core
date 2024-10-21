class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v0.169.1.tar.gz"
  sha256 "4f418481f1e8e7ced52d92160be2291b912514064ec696d92c358b5ead5bc232"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc29d3d375c9c5f349b4ae1545bbed22ebca533f456e452856d784646e8ad88e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5730d4949e918ac5ea7d22fb192b803c494fa9ce8fe9e39c5cfe087ff9f50dd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c22ab5981b677dcb5c0c8a86e2794decb07add235f8fba143bb8129bd80f73c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "50915d0ebd48a78479b243884a4e20c0f0f3fec911886529461f56576acb7b13"
    sha256 cellar: :any_skip_relocation, ventura:       "02e433e0ca6292b77b4bc1cd68b38fe3b139e77c7560c3fe4fc09c28aa0e995a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e839cf21e37c910c17819c13b6f0c6867741531b1c418d231875e6b7950685e7"
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
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"helmfile", "completion")
  end

  test do
    (testpath/"helmfile.yaml").write <<~EOS
      repositories:
      - name: stable
        url: https://charts.helm.sh/stable

      releases:
      - name: vault            # name of this release
        namespace: vault       # target namespace
        createNamespace: true  # helm 3.2+ automatically create release namespace (default true)
        labels:                # Arbitrary key value pairs for filtering releases
          foo: bar
        chart: stable/vault    # the chart being installed to create this release, referenced by `repository/chart` syntax
        version: ~1.24.1       # the semver of the chart. range constraint is supported
    EOS
    system Formula["helm"].opt_bin/"helm", "create", "foo"
    output = "Adding repo stable https://charts.helm.sh/stable"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
