class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.11.3",
      revision: "66a969e7cc08af2377d055f4e6283c33ee84be33"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3be93b9a4c46059b71b8be6f0067a56dda3726518f9927731e9e742950cd7a8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cf3d47fc263b2a799a6bf65400332867c08f9ebab48009175b727572965ce90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52f06b3b61607d5ed429d5a30e9de3f0e58509b837a4223b2ae4d6f1e197686c"
    sha256 cellar: :any_skip_relocation, ventura:        "9f2c604508e906a2597d33021dd480965e65b34388067f63d681fbef682b26e3"
    sha256 cellar: :any_skip_relocation, monterey:       "85a60653169cab003872830e430b40806e507a4cb66cee72b746b8fc438cad42"
    sha256 cellar: :any_skip_relocation, big_sur:        "760cf4babec368cb50e620966082cf7e36a8f7851a3e43cd5441668e6309cb95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89c649f1d47132f539bb6cca1ba972cb0592578393e4a3b1cdf9427fa5b21cf4"
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
