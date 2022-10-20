class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.10.1",
      revision: "9f88ccb6aee40b9a0535fcc7efea6055e1ef72c9"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0907773765ef9f2aacd611097a0e108b1a1b6a1bed676952cc1c437b94212205"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b27cd513c5f28b9792e4a48fc67cc3a6ec3bb9a0af7bc24dbcdf6a39c83e9afd"
    sha256 cellar: :any_skip_relocation, monterey:       "f17c72d19adc8c9bca71c904333ab468fb12cda9b1ecf8d70d108422d2c957bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "98f13d50afa181547e8cf961f4cf7b1d777b893860ac6d68a355f0b8d90b9fa6"
    sha256 cellar: :any_skip_relocation, catalina:       "05b224b3dd5bd0efd977a371adc8c09683e91dd3ea8cd592a512e33873558d74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3eecd83504814390df92dfb079481d5cd4c12d5f76a5fe4ed6b96a1b0ba8620"
  end

  depends_on "go" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    system "make", "build"
    bin.install "bin/helm"

    mkdir "man1" do
      system bin/"helm", "docs", "--type", "man"
      man1.install Dir["*"]
    end

    generate_completions_from_executable(bin/"helm", "completion")
  end

  test do
    system bin/"helm", "create", "foo"
    assert File.directory? testpath/"foo/charts"

    version_output = shell_output(bin/"helm version 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
    if build.stable?
      revision = stable.specs[:revision]
      assert_match "GitCommit:\"#{revision}\"", version_output
      assert_match "Version:\"v#{version}\"", version_output
    end
  end
end
