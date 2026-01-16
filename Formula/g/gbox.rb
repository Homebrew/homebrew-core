class Gbox < Formula
  desc "Provides environments for AI Agents to operate computer and mobile devices"
  homepage "https://gbox.ai"
  url "https://github.com/babelcloud/gbox/releases/download/v0.1.17/gbox-v0.1.17.tar.gz"
  sha256 "48355c7859f009a16147af23a8646f77399a74bab3a36fb591281160a8c576a2"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "011e64ea35e60795521020a58ddece288cda2aeea5ab3d9c17b0708ae3b4f14e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c73213b8085feb62e789eb3168645c386f82dc4d9e7a1249f856bea7b2e0b8ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b56c45c820c82c226dd8839e11d65b7d64fb5dd03c414c294dba87068717008f"
    sha256 cellar: :any_skip_relocation, sonoma:        "81fb41cc0a5ebea3de86eb7cef678d2bd209c837d5311e90bcd640974cba2373"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "757f4a545764e0e23eb71092bd773ecd70be2a4f116e82e332fa87aeb35093d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6707054c068ff37ef549ae54f40c0604938fb28d1ab4afd880b9db1ac2b83913"
  end

  depends_on "go" => :build
  depends_on "rsync" => :build
  depends_on "frpc"
  depends_on "yq"

  uses_from_macos "jq", since: :sequoia

  def install
    system "make", "install", "prefix=#{prefix}", "VERSION=#{version}", "COMMIT_ID=#{File.read("COMMIT")}", "BUILD_TIME=#{time.iso8601}"
    generate_completions_from_executable(bin/"gbox", shell_parameter_format: :cobra)
  end

  test do
    # Test gbox version
    assert_match version.to_s, shell_output("#{bin}/gbox --version")

    # gbox validates the API key when adding a profile
    add_output = shell_output("#{bin}/gbox profile add -k xxx 2>&1", 1)
    assert_match "Error: failed to validate API key", add_output

    assert_match "mcpServers", shell_output("#{bin}/gbox mcp export")
  end
end
