class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.7.0",
      revision: "eeac83883cb4014fe60267ec6373570374ce770b"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "981dd0b115b8c58c445f44a2960b79b7f9709639161d8e911014da09a1b2404a"
    sha256 cellar: :any_skip_relocation, big_sur:       "45fd0dfb23a1d0873a605c114151e4737fbbf097aec401fe03d5b0045bd2201d"
    sha256 cellar: :any_skip_relocation, catalina:      "c875589d2f82757fc1c9f3d08035deb1845f4d7e5587eaecbbce368c0156ebba"
    sha256 cellar: :any_skip_relocation, mojave:        "731bd2ab02448ff37f0bd0ef285ef330c78ad47114ede11c90444c0411933247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e592f9b5de73fdc1956d4714adc3ab05e05ad76077d233f474133fa4893fcdf"
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
      revision = stable.instance_variable_get(:@resource).instance_variable_get(:@specs)[:revision]
      assert_match "GitCommit:\"#{revision}\"", version_output
      assert_match "Version:\"v#{version}\"", version_output
    end
  end
end
