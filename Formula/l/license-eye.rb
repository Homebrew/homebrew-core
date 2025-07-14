class LicenseEye < Formula
  desc "Tool to check and fix license headers and resolve dependency licenses"
  homepage "https://github.com/apache/skywalking-eyes"
  url "https://www.apache.org/dyn/closer.lua?path=skywalking/eyes/0.7.0/skywalking-license-eye-0.7.0-src.tgz"
  mirror "https://archive.apache.org/dist/skywalking/eyes/0.7.0/skywalking-license-eye-0.7.0-src.tgz"
  sha256 "d4663ac8222aa9610abba48670c22bb1ab4fb893bd2f9592c2efd4b6c0225b50"
  license "Apache-2.0"
  head "https://github.com/apache/skywalking-eyes.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "967c6117d179e994b401c6e503c477dec9b3b783a27cbcc30e69f44b7f91fbc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "967c6117d179e994b401c6e503c477dec9b3b783a27cbcc30e69f44b7f91fbc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "967c6117d179e994b401c6e503c477dec9b3b783a27cbcc30e69f44b7f91fbc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b919d6615ed5fa1169c192a1142a853d643b93a954cd9491a199775e8127994"
    sha256 cellar: :any_skip_relocation, ventura:       "1b919d6615ed5fa1169c192a1142a853d643b93a954cd9491a199775e8127994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cdd6daeda967110aec797de72b28d868a1b8620755dfb1cdab2031a78817c8e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/apache/skywalking-eyes/commands.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/license-eye"

    generate_completions_from_executable(bin/"license-eye", "completion")
  end

  test do
    output = shell_output("#{bin}/license-eye dependency check")
    assert_match "Loading configuration from file: .licenserc.yaml", output
    assert_match "Config file .licenserc.yaml does not exist, using the default config", output

    assert_match version.to_s, shell_output("#{bin}/license-eye --version")
  end
end
