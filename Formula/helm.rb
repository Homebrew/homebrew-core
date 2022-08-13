class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.9.3",
      revision: "414ff28d4029ae8c8b05d62aa06c7fe3dee2bc58"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18d8ef435d37d110de1b92c494def35e89540747129dad220941bce0343629b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c01dcd63775af362821222f137f7dc49fcaca687adb8b37adac208a4f5538dd5"
    sha256 cellar: :any_skip_relocation, monterey:       "f9030c9cc30560be2b179428a9a5d53c8986b8339fdb2b8384f2ae77207e5cef"
    sha256 cellar: :any_skip_relocation, big_sur:        "0322ce506fed9ec5ccffc3801e0b1f446cc0d5c601f36b11739fe6c5734cece2"
    sha256 cellar: :any_skip_relocation, catalina:       "366389299cff1674589ec1d811d368bebf86c726671d4553e7737db79aaeca78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e2595b5fbc416f46d664042d3035538af09c946d7b1d0a208fcf84af1c52da4"
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
