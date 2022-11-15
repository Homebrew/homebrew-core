class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.10.2",
      revision: "50f003e5ee8704ec937a756c646870227d7c8b58"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0dfb7919939aa9d2b6618f0b645e419d1cc92933dc8655c6b16e8a95c989d29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa33585f2fe9e0a15ed04632b4c02f5180eca774f4dd214841304d9cf9e87e03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a837bb892d60ef25ad28af3e7d713239042497fc8135fa89994525912cdbe2dd"
    sha256 cellar: :any_skip_relocation, ventura:        "a5c481424794b227bf06931c63950634a2f73b2712de0d3fbdfdee01d510227f"
    sha256 cellar: :any_skip_relocation, monterey:       "52e2580b6acb6ecd425a5344672658b7f1912190346e1d75079f4aec0990ab11"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbc4b33fb618da80ff6c564407404f0f95d33a31ab28e372e483c0671d4d7014"
    sha256 cellar: :any_skip_relocation, catalina:       "4f75fa199da9ad76b3871baf2d04cdbf34235e7f5c38a83d5baa2baa3866a952"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3de7dd1e7b02e9158e619da0b75d361b74b23ed23198baefe0e907802041ad2"
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
