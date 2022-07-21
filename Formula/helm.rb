class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.9.2",
      revision: "1addefbfe665c350f4daf868a9adc5600cc064fd"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d9c0348b7c1dbf02cb1871ceda5b34e85efbb400fe6ce54da1c5be907802e8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6efc198a797a2627ac5a01c368e3036b8b831ca9f03c0385ab78d0f3faf98f8e"
    sha256 cellar: :any_skip_relocation, monterey:       "afaa143c4b21f4360f8c9ef1db9f862c56c6f1c1874726b689f11c30b3f6a295"
    sha256 cellar: :any_skip_relocation, big_sur:        "463de6d80ec8c3ec9ebbfb1a4269f1c1dd02e635768c5b5ddf2cc7ff2dad2c7b"
    sha256 cellar: :any_skip_relocation, catalina:       "3262f66b972d9a5245e47fe525883e3a26245a522f3fb36aae2ab197802f6217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09d34cb12028f2a82f657c020f58784b46a548181dbcac38ce877cc692211889"
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
