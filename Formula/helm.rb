class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.11.0",
      revision: "472c5736ab01133de504a826bd9ee12cbe4e7904"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf8e67d0a71bb12520e3536e3b905ac32f698d06034ace92486bce6ef28968b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bf83cd1d2e6e04e6ae1082c877cf5d3015c647d4cd5dfce8caf1d2bd295db42"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c05c489110a5c44f3670afd22ac3e63d085cc01ddd41ce81c427a1b200155ebe"
    sha256 cellar: :any_skip_relocation, ventura:        "3814d570ceb6ec7177df57eb2e5ce7bbca724e75d9c8a43ec7fba0a8b9058664"
    sha256 cellar: :any_skip_relocation, monterey:       "fe1b3bf4f5f3c5777ce91628665e7e217447e6db711e35e4766352f8a4c10a26"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d5bea06fd3e7bca8fbe73f3b5a11e295349e80f01643ac1ca797b884f390bb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b1ed627be65bc9277cee50a8e2fd2d6e89e0eb9e11e01d080d5b9909a9a2ca6"
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
