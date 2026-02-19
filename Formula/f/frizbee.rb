class Frizbee < Formula
  desc "Throw a tag at and it comes back with a checksum"
  homepage "https://github.com/stacklok/frizbee"
  url "https://github.com/stacklok/frizbee/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "a75eeae7de27228a4103d4328fb98967e7f872537a2863699ad9eb08631bc3bc"
  license "Apache-2.0"
  head "https://github.com/stacklok/frizbee.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54dcefd9c3354478593515dd0936ee3701d233edabe7595becce20314c2e6745"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54dcefd9c3354478593515dd0936ee3701d233edabe7595becce20314c2e6745"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54dcefd9c3354478593515dd0936ee3701d233edabe7595becce20314c2e6745"
    sha256 cellar: :any_skip_relocation, sonoma:        "022944bb6501afcf31939f7098acb449e7f03e6b05d9e45133c257a5d66f7cc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58ac3c352bbb19390d250e6829e5b268a7e95277ffc22545b306e03f566cffde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6faebec6de592e9c9399fb1824b3538331a7f95340d3b8aeba5af3562df9f2bf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/stacklok/frizbee/internal/cli.CLIVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"frizbee", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frizbee version 2>&1")

    output = shell_output("#{bin}/frizbee actions $(brew --repository)/.github/workflows/tests.yml 2>&1")
    assert_match "Processed: tests.yml", output
  end
end
