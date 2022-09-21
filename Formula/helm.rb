class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.10.0",
      revision: "ce66412a723e4d89555dc67217607c6579ffcb21"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01a042f197753d9126f920cffb5292bab41b172d8ce4d04bde8ffdb0904c75f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59ee669d6ac2848c93454675c0d622accd57e0d49f6e829381d436a22460229d"
    sha256 cellar: :any_skip_relocation, monterey:       "2e4345e4e2225f9862283efc39fbf71848f796feae622ea1d6130c553c35b403"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae77f436010a20e0e955c8ecacfeda9f486f950b9ef839ccd12d10a3edfbc6f4"
    sha256 cellar: :any_skip_relocation, catalina:       "aadfbf3143e6b9912c0587a551cf2d77f516dfe8f36c814476a28535f03f9bd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffb49c294b70f83c4156ed922b6862c9754affafdbdfef03fc948c4abd7dff67"
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
