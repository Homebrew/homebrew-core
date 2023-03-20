class OdoDev < Formula
  desc "Developer-focused CLI for Kubernetes and OpenShift"
  homepage "https://odo.dev"
  url "https://github.com/redhat-developer/odo.git",
      tag:      "v3.8.0",
      revision: "9c592c4f04afbeeccf2131491d2ed2f6fb2ba581"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4796275e835d6405a841046958ed02d4a637867c70e96ed7244a797629d7611d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb5331c9e1d664e0b6f49fa461254cb3a080f19d57fd39f68302022c5a27fa64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a19f77b917a46c89a11e0f4064b5b348c6b3b003fc187a287ecf860800482e33"
    sha256 cellar: :any_skip_relocation, ventura:        "4a65df1aab5bd9cf7fc9ed47ae707858583ed654a2d8234a9ed2fae063b68979"
    sha256 cellar: :any_skip_relocation, monterey:       "90cd52daa520ffbf82a5ee83e31f7eeac7b99a842dc868f00fc346ae8e395b7f"
    sha256 cellar: :any_skip_relocation, big_sur:        "68895b61ece4fec5c2a1a2df6bbf0da2f80610c99a4b974a9d434699630f4ea8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b74bb5c20f86c5a0b062f4ad3f55881fc8172d0d6eacaf0db3ac8de1fe3748cb"
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
