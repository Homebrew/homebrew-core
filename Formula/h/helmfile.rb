class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "dc9b62c842068ab7aad6fa82ddfa034b6973bda71322a283cf0a8a5151f149d3"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30a695451baf4fdb66a4fb55c5595a38f3deab7d2eff7e9cfb6f7c091f1a1fbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c18dca341140ac7b83c257ed83786f96e52be82f07009fff7c7fb1fcb2d649b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b3e27bee2d311b62f7061b1a115d7134d03e8114fe42c9e9b9bb9287ec28283"
    sha256 cellar: :any_skip_relocation, sonoma:        "fae9531ded7f81bf93e4b711e75c6b1cb31f915cc5766e2dc36ab4808071938f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "777430c4d0d57bddbd6d1f30a97f4672749493de7cc24eac7e26a99b2889885f"
    sha256 cellar: :any,                 x86_64_linux:  "ae4c24ddff4548957bbf671ed14d48e22c2794ae14851a2df6346344ff130ab7"
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
