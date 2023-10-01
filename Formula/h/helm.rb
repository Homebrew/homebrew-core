class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.12.3",
      revision: "3a31588ad33fe3b89af5a2a54ee1d25bfe6eaa5e"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6561a5127f1e9af1077e651c8cf8023a9e95db56ecc2d7a51a507419a695c79b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ce1749b5cc1231a4b895bbce11a68712ce2869d8326bd503bf1f8d4ab03115f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b52e4999e0ccc4627541cb85f484430b0fd6d4107878f4645ef50b1a91d436cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "487dd976e5b142eca158e999c8ed8029ea0cfb53522577c7e84a43e588794cb9"
    sha256 cellar: :any_skip_relocation, sonoma:         "dbb265fa1e0e22c51814358e1c555dcd6caace6ad2b37de79a01cb773091b870"
    sha256 cellar: :any_skip_relocation, ventura:        "dbcc1ca59dfd245a50372292a3f6129b91aa7bc571c2da2e7728933cd2f747fb"
    sha256 cellar: :any_skip_relocation, monterey:       "0709a21e27cba1faa44fcf12944affa9028e51ba063f03139aa619b9fc3fc602"
    sha256 cellar: :any_skip_relocation, big_sur:        "10d869376e491c44365447bcf83fe638fc1826092b122f316fa373693953a5e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "608141eec9a27bc14b5593429148ac1fe78567caa44eb188f67943a6094bdd45"
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
