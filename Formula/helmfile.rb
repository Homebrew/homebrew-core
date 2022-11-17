class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/v0.148.1.tar.gz"
  sha256 "847ec17b43b19fa292a261d20cd34331f8bd6dccb46d24d9fc6e6632c84955ae"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f2d1f77ada6e4df85f823188818f372e4ccd2b619d2f8213346fee10b24723a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5e6ea4f0159c7b9825586b8b9b01ed7086fe8ff51af001136b3b9ad0f0622ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25993e5b7b793849fdcf0d69d367ae08ab0553c56d4116245efe88d6dff8ae6a"
    sha256 cellar: :any_skip_relocation, ventura:        "6698a75c8a38a188cac656d25b43a4f8cd2212a9679a48daa22e3203eb3a78d5"
    sha256 cellar: :any_skip_relocation, monterey:       "504693a559ab279a298f7127c2709b0ca509007da57f6f67b0b1ab1582b93b67"
    sha256 cellar: :any_skip_relocation, big_sur:        "581b8499b1d2e7e5ba6e17635d2efcba49634422d26821a4b99b2cba093e9197"
    sha256 cellar: :any_skip_relocation, catalina:       "d41688f29f0f34a558a527ef3ca318884bfb118683aef03b50a1544988a3597d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dce940475d9885e0995a94a16d6f26de4f54c659bc1e952e8862c65f3013c154"
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
