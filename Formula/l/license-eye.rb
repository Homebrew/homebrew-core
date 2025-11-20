class LicenseEye < Formula
  desc "Tool to check and fix license headers and resolve dependency licenses"
  homepage "https://github.com/apache/skywalking-eyes"
  url "https://www.apache.org/dyn/closer.lua?path=skywalking/eyes/0.8.0/skywalking-license-eye-0.8.0-src.tgz"
  mirror "https://archive.apache.org/dist/skywalking/eyes/0.8.0/skywalking-license-eye-0.8.0-src.tgz"
  sha256 "cd642a1090ad526fa6517c795c9360916bbb15ed483b3ebc3199ddb9a9821a65"
  license "Apache-2.0"
  head "https://github.com/apache/skywalking-eyes.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f129551508b02f5d729f793a9763c4026204face464a55b8150f3874613080b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f129551508b02f5d729f793a9763c4026204face464a55b8150f3874613080b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f129551508b02f5d729f793a9763c4026204face464a55b8150f3874613080b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "45966756d7bf9ae5bfe0fe6b21de96647fcfb91ef8a7131d86df8f049f047f50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12eb95762b7cca2f8051e874dd1e12cbcb4cff0fcc55eadf63141a0411e01cd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9e1a93e105a6f7d6e651eaa3f3087e25b4f83460ec406ad6f0d6daf994c3a23"
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
