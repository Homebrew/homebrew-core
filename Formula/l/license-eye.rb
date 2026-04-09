class LicenseEye < Formula
  desc "Tool to check and fix license headers and resolve dependency licenses"
  homepage "https://github.com/apache/skywalking-eyes"
  url "https://www.apache.org/dyn/closer.lua?path=skywalking/eyes/0.8.0/skywalking-license-eye-0.8.0-src.tgz"
  mirror "https://archive.apache.org/dist/skywalking/eyes/0.8.0/skywalking-license-eye-0.8.0-src.tgz"
  sha256 "cd642a1090ad526fa6517c795c9360916bbb15ed483b3ebc3199ddb9a9821a65"
  license "Apache-2.0"
  head "https://github.com/apache/skywalking-eyes.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f33dec54a6a87510fd2fa09014df3b7a49cff98db6736faf2ffa98afa2232854"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f33dec54a6a87510fd2fa09014df3b7a49cff98db6736faf2ffa98afa2232854"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f33dec54a6a87510fd2fa09014df3b7a49cff98db6736faf2ffa98afa2232854"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6a0412827b3b186256859307f56089da159720583ca8405956f1bd69757f970"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8e4286769df4b08f934ea4dc7ad42cef78b87ae1a9748d51ef6f56b35f0849d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afeeb07c76862ca5bdd7d8144695a685ff819575e5656515259c7dac7cee027e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/apache/skywalking-eyes/commands.version=#{version}"
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
