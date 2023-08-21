class OdoDev < Formula
  desc "Developer-focused CLI for Kubernetes and OpenShift"
  homepage "https://odo.dev"
  url "https://github.com/redhat-developer/odo.git",
      tag:      "v3.13.0",
      revision: "0d1cf6e3656348ed7996d33e0a0109e37097d62f"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f8119de72fe1f0ecf9978ad52c6b4984a55e3a60f0e169773ab1f6f16e8b5ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a6d2da041915ea029108b76c68308de46fac43981a729c76c346f64a41bc4ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4e048b34cf0d23a148f8b49949c1384f86c2da0fc9547a935c456239851839f"
    sha256 cellar: :any_skip_relocation, ventura:        "75faed9f0695b57284bfd41258a007b01d8e3a8a05224f53b939f9361f06e912"
    sha256 cellar: :any_skip_relocation, monterey:       "92358b23a5ac9688bab898595969f58634c7cf92b3d983a93729f14ffc2585c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "689e91520adfc47172ce826a636a74048b14aad5f1c2535facabbf037745a985"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10ad0d964982afb6700b082f73a8a5fd5bfc5c96ebfbf3571ff9311e1c176d3f"
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
