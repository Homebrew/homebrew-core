class OdoDev < Formula
  desc "Developer-focused CLI for Kubernetes and OpenShift"
  homepage "https://odo.dev"
  url "https://github.com/redhat-developer/odo.git",
      tag:      "v2.5.1",
      revision: "ae0c553090e7644c3eda585639151419a8c3fb6b"
  license "Apache-2.0"
  head "https://github.com/redhat-developer/odo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ccd1659bef55782660366226e5c3b98d59e979c9a33e77c609ba25bb059f19b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07a113911a23917f2d797bf76fcae16fd8f7596fc2f897aa2314e8c8ec6b96e9"
    sha256 cellar: :any_skip_relocation, monterey:       "d9e50dfaaae7aba3c10637c1a49867848409bdd83a78458a7a15933c4c0801ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "915e4475508f99bd976092ccb9982b89877d0ae87b8f9f761a650ad28acb2939"
    sha256 cellar: :any_skip_relocation, catalina:       "7ba020986b1be4cd3b4d919320bfabea50ee575869be6f43860c7851f0078fa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd3d5e5ffb98d731541c5da735965a4b0c65918e2999e8c62b77c0135e491d09"
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
    assert_predicate testpath/"preference.yaml", :exist?

    # test version
    version_output = shell_output("#{bin}/odo version --client 2>&1").strip
    assert_match(/odo v#{version} \([a-f0-9]{9}\)/, version_output)

    # try to creation new component
    system bin/"odo", "create", "nodejs"
    assert_predicate testpath/"devfile.yaml", :exist?

    push_output = shell_output("#{bin}/odo push 2>&1", 1).strip
    assert_match("invalid configuration", push_output)
  end
end
