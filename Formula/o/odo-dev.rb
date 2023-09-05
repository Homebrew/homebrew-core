class OdoDev < Formula
  desc "Developer-focused CLI for Kubernetes and OpenShift"
  homepage "https://odo.dev"
  url "https://github.com/redhat-developer/odo.git",
      tag:      "v3.14.0",
      revision: "471928fead1450a64117411cfa328636ae244cc9"
  license "Apache-2.0"
  head "https://github.com/redhat-developer/odo.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "299c455e9c6eced42e36312b933123511c834933edea9818477601e8d647dd43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45679b9ac766d0e80ddc61819cd0b82801c78868250b4a5961a5630cbec85e8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7eb2574ebd198878284bd314286a6153796d7923e796f5c40d8e151135ed04e7"
    sha256 cellar: :any_skip_relocation, ventura:        "8a3b1d0b586218cec48224a15fcd938d1ffa114d5d969d37f2833a0efc896ad9"
    sha256 cellar: :any_skip_relocation, monterey:       "9243a016b0cf8146179ee13cd4d25175ec9f3215b3d5e370bc33f0c845e4183a"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f783d91eede961b45239f970c305a3cea4280a7ef5af2e4c727f2e6e14a5d65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b538842c3b49e0134b079428c0732b89ba009b30042e8d065b599ff66bb2e6d"
  end

  depends_on "go" => :build
  conflicts_with "odo", because: "odo also ships 'odo' binary"

  def install
    system "make", "bin"
    bin.install "odo"
  end

  test do
    # try set preference
    ENV["GLOBALODOCONFIG"] = "#{testpath}/preference.yaml"
    system bin/"odo", "preference", "set", "ConsentTelemetry", "false"
    system bin/"odo", "preference", "add", "registry", "StagingRegistry", "https://registry.stage.devfile.io"
    assert_predicate testpath/"preference.yaml", :exist?

    # test version
    version_output = shell_output("#{bin}/odo version --client 2>&1").strip
    assert_match(/odo v#{version} \([a-f0-9]{9}\)/, version_output)

    # try to create a new component
    system bin/"odo", "init", "--devfile", "nodejs", "--name", "test", "--devfile-registry", "StagingRegistry"
    assert_predicate testpath/"devfile.yaml", :exist?

    dev_output = shell_output("#{bin}/odo dev 2>&1", 1).strip
    assert_match "✗  unable to access the cluster", dev_output
  end
end
