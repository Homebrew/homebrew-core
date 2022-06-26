class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.9.0",
      revision: "7ceeda6c585217a19a1131663d8cd1f7d641b2a7"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14fc008242f71fef52a1bcc08e6a27fd4e11d6f41c84aab97b68684fa36955bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c04aa5293c2a0a7f197e5c68e59b108ed2c4e763212b14fb35c079ef5804bf4"
    sha256 cellar: :any_skip_relocation, monterey:       "ee5b2e0a917bac5c1c3af5ccb18520505a84645ba27e60dd1eaa0ae5b543bcd9"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3c71ebbc844fcc66af53168f547e25ab25f65a3b0f491d92608e3d89ddb2842"
    sha256 cellar: :any_skip_relocation, catalina:       "7a8b3f8995d97418b293f8b4847c74d3314c38bf72e66f1e7eeaf56a832a5f32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27ff6e13c6e534dab8ab38ca9711f8905fdc93b787d687be48176313bc537f4d"
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

    output = Utils.safe_popen_read(bin/"helm", "completion", "bash")
    (bash_completion/"helm").write output

    output = Utils.safe_popen_read(bin/"helm", "completion", "zsh")
    (zsh_completion/"_helm").write output

    output = Utils.safe_popen_read(bin/"helm", "completion", "fish")
    (fish_completion/"helm.fish").write output
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
