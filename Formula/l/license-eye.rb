class LicenseEye < Formula
  desc "Tool to check and fix license headers and resolve dependency licenses"
  homepage "https://github.com/apache/skywalking-eyes"
  url "https://www.apache.org/dyn/closer.lua?path=skywalking/eyes/0.6.0/skywalking-license-eye-0.6.0-src.tgz"
  mirror "https://archive.apache.org/dist/skywalking/eyes/0.6.0/skywalking-license-eye-0.6.0-src.tgz"
  sha256 "4d2fc42551b7d07c930733968802bd4fd17157c4bc723d6c7cdad867a9fcd2fc"
  license "Apache-2.0"
  head "https://github.com/apache/skywalking-eyes.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3745e11daa3f162dfdb8b9227b365fc38a6b8c7c47fed39a5513b1bdb3590aee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32960a241b58ff4392f75d02fa08c1bab86a694ec24d839f36dde8d68c90cf77"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c178b17ffbdac22ee74067560320bb31da0417e9527679c2f335f236133c7614"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac62c503e1d693cda38478e6f80430f67349575182354926bbcccb026196953e"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c3e2236737d0bfadc5572af143b9a71e12c484830ebcfe2ad7e35dafc9c8890"
    sha256 cellar: :any_skip_relocation, ventura:        "969b10a3f93dc2c1f39fb73407fa0826aa0bff19d8204d76cbf2219e802758ce"
    sha256 cellar: :any_skip_relocation, monterey:       "e08082a93235e42405f1c95e9d7036635ea5f19ef6dc623ee04ddeb8a33ea653"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9655d42858b5eecfea966b2d9320e9e8890cf6b1c012e9e8d572ea3fa73b5647"
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
