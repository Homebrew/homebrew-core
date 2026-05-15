class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "255fc08c0be480cb876b0e98da70a0ec17b5131c749b462799f52d52e1570d60"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99b311e3a4dcbbe032275bd3c46a01e8a78b989af359eb403a3ff6991351b352"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "177d46f508b71cd387e1c54db0af09be2935cc3e4b4aa552e09a77d7957b1971"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37e6b7fb08d182a9824a6f8d54a057dcdfcbe92daa2021d7824882eef4c4d1fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "eaa9b4d4c0f793edcb132bbe581f05f9582f106644d585be24156f97c04d2689"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a939e71a2bb491bacda13df025d75d8f95a1b973f713f59a3b5de3a7e7f48556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f944cc3a837a3c240ab1d5dc06dec5433a82cb80506a39355223fd4dd1c32f0c"
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
