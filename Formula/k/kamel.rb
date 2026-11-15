class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=camel/camel-k/2.11.0/camel-k-sources-2.11.0.tar.gz"
  mirror "https://archive.apache.org/dist/camel/camel-k/2.11.0/camel-k-sources-2.11.0.tar.gz"
  sha256 "aace4782b7f4fcb5ff7c49f8c4ead8a5d33b1139678c6f9253c6c37e83d4e78b"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8a3fb22f87fb964777f33c80cc3fa6ecc9f626584ff4e629e0f001032f2a149f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e239f71b40b41eed60a67c203de0a7ed67aeed95a4c5011ef5a056c0b71ca8c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b2a2eeddcb2a72f46723e0e1d1e21acb07b78c2bc3ee07ee6405394ba470346d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "aa8a655783748da9b94b747f8d9a487b92f6b2bb1deb24eef258d8336121a6e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0243c7919933d6ec4c64b14d75494407b2f04625fe87e3e76a7c9c7c30000690"
    sha256 cellar: :any,                 x86_64_linux:      "8610e91f36d8417d62c746f4c2c9c5678c9e961ec4eb5426c8b28903457abc94"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/apache/camel-k/v#{version.major}/pkg/util/defaults.GitCommit=#{tap.user}-#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kamel"
  end

  test do
    run_output = shell_output("#{bin}/kamel 2>&1")
    assert_match "Apache Camel K is a lightweight", run_output

    help_output = shell_output("echo $(#{bin}/kamel help 2>&1)")
    assert_match "kamel [command] --help", help_output.chomp

    get_output = shell_output("echo $(#{bin}/kamel get 2>&1)")
    assert_match "Error: cannot get command client: invalid configuration", get_output

    version_output = shell_output("echo $(#{bin}/kamel version 2>&1)")
    assert_match version.to_s, version_output

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Error: cannot get command client: invalid configuration", reset_output

    rebuild_output = shell_output("echo $(#{bin}/kamel rebuild 2>&1)")
    assert_match "Error: cannot get command client: invalid configuration", rebuild_output

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Error: cannot get command client: invalid configuration", reset_output
  end
end
