class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.9.0",
      revision: "7ceeda6c585217a19a1131663d8cd1f7d641b2a7"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78901162559cfde0d695e74c82e78a8f37f7d0cf9a2a0a613a6a694196e57f50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0516554247a183ea3a7c404a217b3c320f78fdbebc59ae58ad3088fb7d8448ff"
    sha256 cellar: :any_skip_relocation, monterey:       "300526edf608faec380e94684fc5561e6640d574ee76f7975340ca6ef7c3dca4"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a5af378b7905afe6a6edf7beac1deb6ad05b9f38a85c274e2debb6a10c3d5be"
    sha256 cellar: :any_skip_relocation, catalina:       "85af7192de62274fd60598b0d1486f5efe9c25afaa725e8311c8c46c44e7158b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db18f47ce16dddaecc48be564eb6b4782b9f85ad3ff7a42274bf535fb719aa3b"
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
