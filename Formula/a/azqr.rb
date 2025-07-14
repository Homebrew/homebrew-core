class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.2.7.0",
      revision: "3ac4fdc75cc6faa5a76fc909351a6c7c8215fcde"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03d3a5b1e7db4a916dad777e6137715741d4d5228f66059edb0312d7f49d8594"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03d3a5b1e7db4a916dad777e6137715741d4d5228f66059edb0312d7f49d8594"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03d3a5b1e7db4a916dad777e6137715741d4d5228f66059edb0312d7f49d8594"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a7dd3afb34ab2ab089c6fec3e34ac04615dc0873eb0f9fb19d8e8009ab95f5d"
    sha256 cellar: :any_skip_relocation, ventura:       "6a7dd3afb34ab2ab089c6fec3e34ac04615dc0873eb0f9fb19d8e8009ab95f5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1595eeb4568f4769befb2368be2519d4e701c89ba1b613ba3075772ee9c51746"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Azure/azqr/cmd/azqr/commands.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azqr"

    generate_completions_from_executable(bin/"azqr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azqr -v")
    output = shell_output("#{bin}/azqr scan --filters notexists.yaml 2>&1", 1)
    assert_includes output, "failed reading data from file"
    output = shell_output("#{bin}/azqr scan 2>&1", 1)
    assert_includes output, "Failed to list subscriptions"
  end
end
