class HelmAT2 < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v2.17.0",
      revision: "a690bad98af45b015bd3da1a41f6218b1a451dbe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5758c325702f7f1e630e10a31075cc1a9a19ca047626fee6f3ad36775dbaca7d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7372a593968befdd89f52a079360d4096be38df500199cec1de53b9d9a047502"
    sha256 cellar: :any_skip_relocation, monterey:       "58b5f2ce65b8c15288e235dd8938e599a4762e1a98d25608dc91282f6761a924"
    sha256 cellar: :any_skip_relocation, big_sur:        "432e81bffefbb026bd50058e920a424b1805b84efc634d78c93dfedb9fec3d5a"
    sha256 cellar: :any_skip_relocation, catalina:       "831c4f5b7cf7fc1ab53364eeb2eeb6eff8babdbc51817b406b65a948ac6258c2"
    sha256 cellar: :any_skip_relocation, mojave:         "ab7ef44ce55c8b3597a2cb6dfe0ef93b74b389e6a4d6ab09c9a1ebe8dce5e594"
    sha256 cellar: :any_skip_relocation, high_sierra:    "a1c5cb86cce4fe2941c94309c8c75cd00ed9fae2e6edc6ea67aacadcf2f13c9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "718dfe0a0929ae4e4566954651c646ba6bab37dfd0a6ffac64740d0423461922"
  end

  keg_only :versioned_formula

  # See: https://helm.sh/blog/helm-v2-deprecation-timeline/
  disable! date: "2022-07-31", because: :deprecated_upstream

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    ENV.prepend_create_path "PATH", buildpath/"bin"
    ENV["TARGETS"] = "darwin/amd64"
    dir = buildpath/"src/k8s.io/helm"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "make", "bootstrap"
      system "make", "build"

      bin.install "bin/helm"
      bin.install "bin/tiller"
      man1.install Dir["docs/man/man1/*"]

      generate_completions_from_executable(bin/"helm", "completion", base_name: "helm", shells: [:bash, :zsh])

      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/helm", "create", "foo"
    assert File.directory? "#{testpath}/foo/charts"

    version_output = shell_output("#{bin}/helm version --client 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
    if build.stable?
      assert_match stable.instance_variable_get(:@resource).instance_variable_get(:@specs)[:revision], version_output
    end
  end
end
