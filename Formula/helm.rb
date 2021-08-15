class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.6.3",
      revision: "d506314abfb5d21419df8c7e7e68012379db2354"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a100ed75ad8f60c46812bdb2e8fde42d49d91c5f226e2ca47eae2b98d43f305d"
    sha256 cellar: :any_skip_relocation, big_sur:       "000b9a1594c8e8c8eb8e7a73b4f09c34b60c2e8a0808939b4005a1b9c4f1de5e"
    sha256 cellar: :any_skip_relocation, catalina:      "7e0ef64afb6fa4e9bfc1c08d78d30ce333e54fbb89056e6f1f367b551415687c"
    sha256 cellar: :any_skip_relocation, mojave:        "637c6cad1bce90f3709e9af61e9bbb0e58a5b3dae2fd1f8851bf9865a3eaa8f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1870c23d532a90e973a88f24b5c812595f4c4a186596b0bdea53d97b56f634c7"
  end

  depends_on "go" => :build

  def install
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
    system "#{bin}/helm", "create", "foo"
    assert File.directory? "#{testpath}/foo/charts"

    version_output = shell_output("#{bin}/helm version 2>&1")
    assert_match "Version:\"v#{version}\"", version_output
    if build.stable?
      assert_match stable.instance_variable_get(:@resource).instance_variable_get(:@specs)[:revision], version_output
    end
  end
end
