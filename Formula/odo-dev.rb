class OdoDev < Formula
  desc "Developer-focused CLI for Kubernetes and OpenShift"
  homepage "https://odo.dev"
  url "https://github.com/redhat-developer/odo.git",
      tag:      "v3.6.0",
      revision: "5b4959272f71b2113f6d29f17d035bfd83781575"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79f6e74e8e605335aa6b841b328fcb014b4680dc2d41de4d49293f0976a6a7fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acc7899b7060ba2ed4c4dc1883ce0c91ec104b39307b5369dc34d9017839293f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "592bad9e4cb0265e45a1a4d72c997e5862b37736f4067c053de3d46f17fe4065"
    sha256 cellar: :any_skip_relocation, ventura:        "66a3e2b392787b1db2688f8b4d7cedc8ec1b4150eb016b4c6e47a9ee29c7f236"
    sha256 cellar: :any_skip_relocation, monterey:       "da8c0f9401ebd8077757bc5ea2641054675da4152c08a3aa2b1d19e61cb25d2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0d2dce02165cdf883b358c7129f138a1d46cc38c86c6dcf8c1e4d63e5a47f1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73dd235856ef918800d0fef88f6609adfeb26c8ea4c9dd447bcb804cdcc42032"
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
    assert_match "no connection to cluster defined", dev_output
  end
end
