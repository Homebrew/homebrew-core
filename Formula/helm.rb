class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.7.0",
      revision: "eeac83883cb4014fe60267ec6373570374ce770b"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f95211c81c4c5128bb1b0c6f3eb20820e864317ae332d2aaeb905264aee4a897"
    sha256 cellar: :any_skip_relocation, big_sur:       "eda6fb39f3ff1ea035eb17df32da654d0336ab529bf8a7b3661024fa917489c5"
    sha256 cellar: :any_skip_relocation, catalina:      "9e852bf21732e4256ffd789d1a79d070d3291bcd2b45dbd853fecb8be30e5887"
    sha256 cellar: :any_skip_relocation, mojave:        "89551dc9d21cb719d14280bc6d062a7220208a7a8c87a3a089f5692de395421d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b47de26d548a5e248112805094eb69ba854f74cb81d2b09de954f4cc6ec3e919"
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
