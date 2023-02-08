class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.11.1",
      revision: "293b50c65d4d56187cd4e2f390f0ada46b4c4737"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f551037b6c3cc495f9398fd1dab4ad6c6ed99de81821f1b036ae98038f4920f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0984f7a6a3e1bfd188b06a127b33da09f16fd6c28f87cae1457b93eccc309fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01ac2e0f1f2a039541356cf5872ddefe2d2647fd8a0e89004e2d77dbfe006a88"
    sha256 cellar: :any_skip_relocation, ventura:        "784e67c13ea5e2f0f9fb41ab294073cab83ae8f8416d192baa9e66038e107415"
    sha256 cellar: :any_skip_relocation, monterey:       "d278a10c08f852ceb83283bfe164260c547f5427a569585a3dbd9900ca946f42"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a28cf21a9c6c001f79c4a4fc59c833753322c40daeef97775fa8a8167c72baf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7e65b3ab5b9471873c9842e2e03ae5640ef572b6f4ddd9cbe3a9f0d91587a41"
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
