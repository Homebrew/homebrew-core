class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.8.0",
      revision: "d14138609b01886f544b2025f5000351c9eb092e"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1977cc21ec3c1acdd86e72bdd8ed51b3e11b5011d3ea29f7c3be25c6809a596b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c496a01e9df3913a1d599390bd1eb799b4e78a0d374709e861c5c78e70c1b3c3"
    sha256 cellar: :any_skip_relocation, monterey:       "94acdc46d632c74ab43825d9de149632dacc681c12bf1c86db3901d5557cc628"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ca57081dd1824897ad5cd6ce17dcf1f522f61b712a23ab3fe755358095f6821"
    sha256 cellar: :any_skip_relocation, catalina:       "8da6ec0361f199fbf0ab9ecfe52b1e4ebc827b4c1baba2aa5ba01de68011968a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99d9860d8ee80e7d304f8bcf6d219ffc31e103373b92657c9e0a6f71fe266d78"
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
