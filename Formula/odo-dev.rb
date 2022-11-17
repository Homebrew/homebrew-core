class OdoDev < Formula
  desc "Developer-focused CLI for Kubernetes and OpenShift"
  homepage "https://odo.dev"
  url "https://github.com/redhat-developer/odo.git",
      tag:      "v3.2.0",
      revision: "233c817c5024ef4ac5433fb50fca1ae95bbd68ba"
  license "Apache-2.0"
  head "https://github.com/redhat-developer/odo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fee6f90e8dacee693a5726593d17dffdcbd226ce631b43da6fa7fb952f145daf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10a57c9d116399f0f09371c61ce24affe2f1194e268ff894d6017a9911b2dd4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab3587465527219ae1feb721336c6ed02e42a22605f1bb620fa4fda91c91e7a3"
    sha256 cellar: :any_skip_relocation, monterey:       "314f1931a6165c558f007bfb92a41c2fe4208848c136a247bbfa12f6a53d20ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd03cdf03e9b7fb80113ba7f3a5d52e6f56e87517153c04cd4ea6e98d6101576"
    sha256 cellar: :any_skip_relocation, catalina:       "dbad3c37d9ca1f618071f5b28abb873e7f13c5f208cb35d86d76d32de0b7ab90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76d23c1ea27da581705e326ad4d1d833a8b41e318583f7daaa280b956c32efa6"
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
    assert_match "invalid configuration", dev_output
  end
end
