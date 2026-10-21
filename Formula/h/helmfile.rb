class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "641e9eec8ccd402bae60254ae29dfb144f02e16e089f5777b5465b04d12b241c"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ccf478f6e52f11af9fb5ac98c5251c6ffceb8bbd9c86e4c2241b122ae13a582f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0f317ccca9da0e34eb9a149c743762203183f89e9bc2270300474bcba96fdf8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "de76787e9dda6b0b2d1aa5cdf3eab2ed5e96570ff12febade8540316ae949887"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1d0365ffaa4dc2cc66b1820fa7cba44bebfc63aa141b1ea804010f20bd2d38f2"
    sha256 cellar: :any,                 x86_64_linux:      "98fad092a73f9b9c88b69c7d8e9c2ad1a2f2add88ef90c7a93359844ae44c875"
  end

  depends_on "go" => :build
  depends_on "helm"

  # `test do` block adds a helm chart repository
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X go.szostok.io/version.version=v#{version}
      -X go.szostok.io/version.buildDate=#{time.iso8601}
      -X go.szostok.io/version.commit="brew"
      -X go.szostok.io/version.commitDate=#{time.iso8601}
      -X go.szostok.io/version.dirtyBuild=false
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"helmfile", shell_parameter_format: :cobra)
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
    system "helm", "create", "foo"
    output = "Adding repo stable https://charts.helm.sh/stable"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
