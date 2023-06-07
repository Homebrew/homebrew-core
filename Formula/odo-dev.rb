class OdoDev < Formula
  desc "Developer-focused CLI for Kubernetes and OpenShift"
  homepage "https://odo.dev"
  url "https://github.com/redhat-developer/odo.git",
      tag:      "v3.11.0",
      revision: "b481d4c4106f5abbca50d2608415d0c8c5485dac"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0cc92ff03d4626e9f83597aac895f7e7704856bdfcd2cf902680d91a6b642b79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d6a82db943e065fd0a137e379ce4c7a7644fbdf56e85ada61e3fba2de845209"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20238da7f1999cb56eece1b985caafc68cd082225588ce422cb15ecff2647c64"
    sha256 cellar: :any_skip_relocation, ventura:        "b0b743b3c0fed79e40b2d94528c38874def82f136167287d4d30c48b5cb96850"
    sha256 cellar: :any_skip_relocation, monterey:       "5c66ec252126b4a33a9c4a8de2fb1b913179697c18197ebdb8be86d1913f749a"
    sha256 cellar: :any_skip_relocation, big_sur:        "faa0fa822121c780096769ea95d084f1820c8f5f0018c6c9cbf5714647f40f25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29b84001eb68e2e598cbb436f35904e7853b899dbea7c9455c76d60f11241033"
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
