class OdoDev < Formula
  desc "Developer-focused CLI for Kubernetes and OpenShift"
  homepage "https://odo.dev"
  url "https://github.com/redhat-developer/odo.git",
      tag:      "v3.9.0",
      revision: "8cb53c2a04312adbd44d240fcc48c1e122f23b98"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e423aa83455aeeabc067c6add3a0411dc37e997a56d30df87960720ec3f4b03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec3c59b44ea762ade47c3cb7e713a674decd82ea6b7325ba082b33a479b0bc1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f7279933e5bb76390e46dd1a23e38111d6d4cb85980a74c48347e9448a89197"
    sha256 cellar: :any_skip_relocation, ventura:        "5b6f67c42950886eea71d3a58df146871fbcab512db987c1d07d576189a39896"
    sha256 cellar: :any_skip_relocation, monterey:       "95d6438534fc8d17d066a3b6c231ad6a32200e2d6243c0861da220f5aa2d2813"
    sha256 cellar: :any_skip_relocation, big_sur:        "87fd4fc1f56305c0518cddf2f11f7f37cbe2fe5554a6f8768454e79fb6660485"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75ca22beab18f9359fbde1bb4129f9307586b4be9eccd0d2487f20aad50a96ee"
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
