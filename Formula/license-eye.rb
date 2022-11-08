class LicenseEye < Formula
  desc "Tool to check and fix license headers and resolve dependency licenses"
  homepage "https://github.com/apache/skywalking-eyes"
  url "https://github.com/apache/skywalking-eyes/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "9a8f9dc34772a1357dc4c578b065f07e1492230b7d767f91bffa5fd212c9a258"
  license "Apache-2.0"
  head "https://github.com/apache/skywalking-eyes.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/apache/skywalking-eyes/commands.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/license-eye"

    generate_completions_from_executable(bin/"license-eye", "completion")
  end

  test do
    output = shell_output("#{bin}/license-eye dependency check")
    assert_match "Loading configuration from file: .licenserc.yaml", output
    assert_match "Config file .licenserc.yaml does not exist, using the default config", output

    assert_match version.to_s, shell_output("#{bin}/license-eye --version")
  end
end
