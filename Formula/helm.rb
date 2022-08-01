class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.9.2",
      revision: "1addefbfe665c350f4daf868a9adc5600cc064fd"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "267d9449429e7633388880cced7dfe359a032718d8960a59572d860b76a54478"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35a7876ab770f7505bae5449ca7c615496be87bb6e7ffe2c79297b7f24a96c8e"
    sha256 cellar: :any_skip_relocation, monterey:       "48df7e1388c36af58c8de21103efdc768fc00eba9da501debf5f11f0e4f0f2f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "e261b4048bf9100b62225b7fa77f05b486cb932bc0da3875deca204ef872de83"
    sha256 cellar: :any_skip_relocation, catalina:       "4f0b0377b406fd332ed5a054942942d9056ffe9c52d40dcfcfcdea1116d2fd4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "859edc1297957f1f61e438257268ca11d7b72a51889e678747b60278fb28f809"
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
