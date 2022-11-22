class OdoDev < Formula
  desc "Developer-focused CLI for Kubernetes and OpenShift"
  homepage "https://odo.dev"
  url "https://github.com/redhat-developer/odo.git",
      tag:      "v3.2.0",
      revision: "233c817c5024ef4ac5433fb50fca1ae95bbd68ba"
  license "Apache-2.0"
  head "https://github.com/redhat-developer/odo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4c908dfd07ef13114c63d7722012ed483c9cf09c396cca65c91bc25972c5145"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d405f7f4d8c103bd16599fc290cf79f756674884174838eb0199a687baf79f34"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17eae343c775c1a6283bc35fea10a124b844d4e96e047389d51988669023f9b5"
    sha256 cellar: :any_skip_relocation, ventura:        "5adccf4774096cd2cabcd9de2c1f5b26a303093efd0f2ea8e86509b8850729ba"
    sha256 cellar: :any_skip_relocation, monterey:       "25e62844e17bf9cf96d08f31eeb71866383cfa2542ff1dee12cfe071ebed1bad"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8cd0e6f18e5b1bdaa15e1f394d7d2b09930aeacb8133eed8956ad3792310d2a"
    sha256 cellar: :any_skip_relocation, catalina:       "cca484d07457a816d1cc629e4e2d113b70ba8113e349ebbe56592305072b589f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc13c25422311f5d7fa940bcc5cada4e12b7a213bec2cd1c8c1f052750496b25"
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
