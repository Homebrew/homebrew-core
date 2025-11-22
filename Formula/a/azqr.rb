class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.2.13.0",
      revision: "9349a99a4376941b133a78460ac0321b0188a727"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "226eaa992f1526d3d6768a49a691a116ebd59668da34e806943e69a5dde50485"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "226eaa992f1526d3d6768a49a691a116ebd59668da34e806943e69a5dde50485"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "226eaa992f1526d3d6768a49a691a116ebd59668da34e806943e69a5dde50485"
    sha256 cellar: :any_skip_relocation, sonoma:        "fdec2fe9cc9a0c46d75fba2c3346a53653ff1a544070789f71b68bbe0b938052"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1891d400596a5616ac370cfd32ca2febf9149913d8e8eb7f86b009711dab48b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2395b96e0ee9857eef36cadc3288cfe383c6c5d30e6d5e09d06fa262d0e5ce1"
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
