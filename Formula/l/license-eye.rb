class LicenseEye < Formula
  desc "Tool to check and fix license headers and resolve dependency licenses"
  homepage "https://skywalking.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=skywalking/eyes/0.9.0/skywalking-license-eye-0.9.0-src.tgz"
  mirror "https://archive.apache.org/dist/skywalking/eyes/0.9.0/skywalking-license-eye-0.9.0-src.tgz"
  sha256 "59265a26cbf51f24eeace490eab59c82513c7428d7ca26e004df8e94756027e6"
  license "Apache-2.0"
  head "https://github.com/apache/skywalking-eyes.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aa7ff974898254b0db32bd73da29ee0c2994f62704227d87f17a014fa60370f9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "859a34afb8a63a1c46aedbf8d735269f2e0b463e45d8a706c380387f2316ba07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "859a34afb8a63a1c46aedbf8d735269f2e0b463e45d8a706c380387f2316ba07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "859a34afb8a63a1c46aedbf8d735269f2e0b463e45d8a706c380387f2316ba07"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7aa8766beb6a6586b09f8b23eea4d55f922b0ef0420dfe86f03fe682d62795f7"
    sha256 cellar: :any,                 x86_64_linux:      "da770b0713952cf3c2ba72d7471231568c2e04547a7e70801a80f43376682ac4"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/apache/skywalking-eyes/commands.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/license-eye"

    generate_completions_from_executable(bin/"license-eye", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/license-eye dependency check")
    assert_match "Loading configuration from file: .licenserc.yaml", output
    assert_match "Config file .licenserc.yaml does not exist, using the default config", output

    assert_match version.to_s, shell_output("#{bin}/license-eye --version")
  end
end
