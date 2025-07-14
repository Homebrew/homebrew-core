class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "0d8dc12c818837114d1c8c8b4f2eed603f159c881dd92d87a024e3ec067037cc"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6de1818527e1ccf941707476fbd3d25e69fdaffc4e14a998724f9ac3aa0ca5b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9430bcfc535bd2a5c93409ea8c39277268256be1e9a3745254b99dfafce875ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "499377a0d0635e08d8be1bc76d3831d50d3ec0410007d98ab20ceb6c0b2bfbe5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3c65e799023b53d05d1c5467b91f8db25e4438f2b907be4476cfed1276d2c69"
    sha256 cellar: :any_skip_relocation, ventura:       "3a759a10f9c383219d53c1faf2a62460e7195561eb20d33ce14737999b6ff7dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08bd6ecd41369d4cb9f5c1d99300dd52d4c2aea13990ebecad1960f2fd9a99ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d96ef936564e23e51c7c2b40aa0b157e6b9b03086e9aa71d9abde43828dfd68d"
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
