class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/v0.152.0.tar.gz"
  sha256 "fa3e67256cee969339fa1c44c2f2339b4a9c396fb616a429fb91cdcaad23fd7b"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2887f5852b8a7d934a0813e1e2e258014733ac433334b474740a69c18c693933"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cc34a5961d237da20ee4d8bbca5336d7ff31615aec35d25dfa6196d0c63d952"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc37ceccd04f0b266fdf53d5add97294652b03ea776e41005028daa6fe0f77bd"
    sha256 cellar: :any_skip_relocation, ventura:        "96d4e7575fc5f36d5ac2c69af156531e5f0c9c0f5c227bfe15243f1adc373f6a"
    sha256 cellar: :any_skip_relocation, monterey:       "34c2eb6c579885a0dac561d897b963d952d2cb61d50d174b60135bfaf1cc95bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff46206e46ff785cae11057aca86a46e88d3deae395c778733bc803752e7bd4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6945c3329df7f9fb04e096af0cea9602f94b68629e790e5d48712bacb912f49e"
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
