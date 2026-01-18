class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.2.15.1",
      revision: "cbe57a891e6811befe91069f4d9ff3f74b902e9d"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "471d80c70f668c62ee4a68c6b85d9fd63bc73188e533b47e7190f06401aff48b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "471d80c70f668c62ee4a68c6b85d9fd63bc73188e533b47e7190f06401aff48b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "471d80c70f668c62ee4a68c6b85d9fd63bc73188e533b47e7190f06401aff48b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9070f96711a42936b99d67fb6c9e1af8ca758936d7627b8d240b5d97672fabb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14674817790dcedf7013b02b09b05fbcc46de04bcdb312f53a2f6f75a6fe7901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2cf8ace0bd97879949cddd9cba6d63e4870dcf89fa355680e3965bb57753db4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Azure/azqr/cmd/azqr/commands.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azqr"

    generate_completions_from_executable(bin/"azqr", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azqr -v")
    output = shell_output("#{bin}/azqr scan --filters notexists.yaml 2>&1", 1)
    assert_includes output, "failed reading data from file"
    output = shell_output("#{bin}/azqr scan 2>&1", 1)
    assert_includes output, "Failed to list subscriptions"
  end
end
