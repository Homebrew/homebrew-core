class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v1.1.7.tar.gz"
  sha256 "3ae8a6d12af2e6d2a0ee7a0921a22f6999c63401bcf6f86c195450c4359856bd"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19c087f3c4220541517a8bafa2f9ff9960ca19471169a8fd75512103dac08919"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01632f4bf605f1fb37d6ddb3594788ad364fd53d7daac6b6ac25351e213efa0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "963a9dc46ea0e1872c5bfc3e09741c89f14fc62150fd0bbc5a593e38abc7efaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "5131bae0aeaec0ca94b9b195aa906f3626a17c7d61231f10f96759997d1db992"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca379bef7b3febbd09b58531b1f81171038f226c470ef97100aafdc7a9fad723"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c98e35a6a8300b6c979631896dd96cb9d99610589537a88e32d32a01d9b3ab4"
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
    (testpath/"helmfile.yaml").write <<~YAML
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
    YAML
    system Formula["helm"].opt_bin/"helm", "create", "foo"
    output = "Adding repo stable https://charts.helm.sh/stable"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
