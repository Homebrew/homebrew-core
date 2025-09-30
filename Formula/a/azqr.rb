class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.2.9.0",
      revision: "7c26908fd42e328c7b8e6e98413fefd8d6146877"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f12aa92f2b2e5d3723440d4a29bc95edf79ebed45c1432855689baf5f61997b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f12aa92f2b2e5d3723440d4a29bc95edf79ebed45c1432855689baf5f61997b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f12aa92f2b2e5d3723440d4a29bc95edf79ebed45c1432855689baf5f61997b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "be19a63b8106d3bcf75effeb21d65f30c2afae62ba5048e0897ec53435c8760b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ab897854315fafced9ab519a72154d5b6e171eb2ccd6ffcfd794fd0b4cdd6e2"
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
