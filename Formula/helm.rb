class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.8.1",
      revision: "5cb9af4b1b271d11d7a97a71df3ac337dd94ad37"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83c9dcf7defcec0041ae3fc26184a8792a9dc7dfd232de170f6ba21bc56f18bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bcf36e8eb03e725aac5ec46bd57d7742ac0f28991cfedf76e09820458f9db44d"
    sha256 cellar: :any_skip_relocation, monterey:       "31c92a2229f3bd40ceef0d8d5a8c4d2ec162e9328489b353f4eab7194e08000f"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a38c1218b293c5b75aa7b8ed72ba65e85e8aa4e4bf59735f2a32300fc591d9c"
    sha256 cellar: :any_skip_relocation, catalina:       "f9bc75bf0b9d05c21ef97aef95c8a332023d38b6967df87d8485438d7364ac8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36cb1e62f9af1ba91762ae3a082135698c42bd1c13ec5e0c264aca150dd2d985"
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
