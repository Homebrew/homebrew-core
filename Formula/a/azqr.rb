class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.2.10.0",
      revision: "0d3864a9c80f2c31c59374d7acb13eb0c97c614b"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "825b2312f6e216b7116de4db59c112db444a5cbf5088c7de30fbb0c086008c0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "825b2312f6e216b7116de4db59c112db444a5cbf5088c7de30fbb0c086008c0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "825b2312f6e216b7116de4db59c112db444a5cbf5088c7de30fbb0c086008c0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "11354d981dbb53948c35d6a73567c74d2a82934508f6590eb3813d6f8c2eaf9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04dab884f823fb26c273b81edbe59073521f1b9c9bae0c59f176ff5479a3e42f"
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
