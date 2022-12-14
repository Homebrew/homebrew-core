class OdoDev < Formula
  desc "Developer-focused CLI for Kubernetes and OpenShift"
  homepage "https://odo.dev"
  url "https://github.com/redhat-developer/odo.git",
      tag:      "v3.4.0",
      revision: "b8662ef743e66b410b8ee01db686636dd0f99e7d"
  license "Apache-2.0"
  head "https://github.com/redhat-developer/odo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6093ae76d2f8c7cea1554e71807935fb81b064f99c2cc32114d94c1023dfa1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78cd0cf54df20a6853646aec52f8ad8f88fde0136b42800a289d2cbf5f35e178"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc3557e0746e423db29db24514446e0fbe2b15f1633e88618698202adea82b1c"
    sha256 cellar: :any_skip_relocation, ventura:        "934e63bbfc064681cd661e9711df93749ef5babb092112ba753f5cf569f8d09a"
    sha256 cellar: :any_skip_relocation, monterey:       "9ef5f2bc6ec401a6bb3be6a0c6a0b0a12696237ef63103779beca05a8f377211"
    sha256 cellar: :any_skip_relocation, big_sur:        "d45fd671356ff7a16635d73a20b99065a90eb1fc446bbe65099bad53620a45ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e49bccd7a4db66ee0b7fd382bd8c72f48e570fbaffd3f8686a05769de6988bc"
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
