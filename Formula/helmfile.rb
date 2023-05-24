class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/v0.154.0.tar.gz"
  sha256 "0f9c3ff65d226c11b1fab9b8c94ffe5e4a8a0605d317cea855469e683a217a42"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3060d8a2002963f5775d51befd3bd5228574d9ef9abe8a39e948698ebaf677f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f04b8f017f8d703f42432b963f96f44e5f472d1dcdb5269e774e25d9a364b743"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1edb8b22dce17e2cf9f30e44f379cdcff99b5052acf0e6532515cb6278ed352"
    sha256 cellar: :any_skip_relocation, ventura:        "3ce7c39b9f1fbf079e2928a64913ff50b9f02d56f52cebb5b0393c631c7b0915"
    sha256 cellar: :any_skip_relocation, monterey:       "49365321a8351aa9b4a88399e9806c2ecb1f34a4f62e59224e8c65efd7a6a01a"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d64335b0da7595d9adf5e95b7e4023f42b743633564365a8db3e15d1fff8bff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a490a4899e68faf790071b2c950d43814751eb776342b2d97b35e732722d14f1"
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
