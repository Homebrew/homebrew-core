class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.8.1",
      revision: "5cb9af4b1b271d11d7a97a71df3ac337dd94ad37"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d5e2864787a464e0a1d723cc5cf7b5bd274505da6610e5f05fff8c1de97b62b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a265288e1c4708c095e96b7379c46a292d34fd4a9698a63d04e807daeb5566a9"
    sha256 cellar: :any_skip_relocation, monterey:       "32f1bae52edd37b8c8609c6319194079ed0c180f7beb46edbee8e5eabcf2f03f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5f3b5eaf39f5c7484b68b1fa9bac2f475f48ae73ffbf622388a25890a98aa71"
    sha256 cellar: :any_skip_relocation, catalina:       "69fb22df8c40f82f9828fcfa5f7b1315290e76c0d3e1aeb63d9e326c90388cd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "008258f793afcc50b8d9c0542bcd4ce716d63197931fdcf456567eee546b81da"
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
