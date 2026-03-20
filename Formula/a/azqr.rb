class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.3.0.3",
      revision: "3ce4d85a71c278926bfec18513ba0ac39a88b030"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e522366c4ae32ff4cdddd433afe51e6e4c8cfbe78d54bcdb635ec47b9014862b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e522366c4ae32ff4cdddd433afe51e6e4c8cfbe78d54bcdb635ec47b9014862b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e522366c4ae32ff4cdddd433afe51e6e4c8cfbe78d54bcdb635ec47b9014862b"
    sha256 cellar: :any_skip_relocation, sonoma:        "67c9c270c84ddf58200da29452ae06c236a627915ab658cd936f8e82f81acd33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b393b20fc5a2d4717764a4f4aab6a2cca92b6e36097e19d394b5cdc4fc63ff0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87809a81b37dc2874a79f0d1267e45c53216575e3017c19c9215472d777b1128"
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
