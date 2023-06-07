class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.12.0",
      revision: "c9f554d75773799f72ceef38c51210f1842a1dea"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6aef10dbe81a11328c69a92bf6eae6ea90012defe123aa63d80bf6478f155c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "259e5b5482f7c478f6678649e957a414518f7ec2d5f673887992fb95381f4804"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3077a2deb7e79057a444ca885b65c6c29946d7674cf69b2ffa1f37d548f7ff5"
    sha256 cellar: :any_skip_relocation, ventura:        "63d5f5ef6b6339253d7be02531619b41921f89e32a81007be753dea10cceaeb6"
    sha256 cellar: :any_skip_relocation, monterey:       "245218d5a243c0ab07967a835189b29003d518754a01325f99fcea735eb31ca3"
    sha256 cellar: :any_skip_relocation, big_sur:        "95be35766b72796cf1d59c49d91787b1a3be3cf030f1ab4ec04230bee7c3b7f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f12d79ca2c6af6a8c2405bd1a1158a6dc1c5bf72f841db5b66bd3d47f4204da"
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
