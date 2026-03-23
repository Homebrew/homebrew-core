class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.3.0.4",
      revision: "bb91ee76296876dcd00914ccee0733d01da2ef61"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02e11a5457fad70a86a130e96a4ea48cd660f454e407a38364d4d4e5a477c30c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02e11a5457fad70a86a130e96a4ea48cd660f454e407a38364d4d4e5a477c30c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02e11a5457fad70a86a130e96a4ea48cd660f454e407a38364d4d4e5a477c30c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e67838420ea4c7bee3c5e3ad7b3e44c762d9e175531e0558e4738281fbd028fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "438cf119923f031803cc00ebd230cbc7f62d6abac5fe7900c7acd8f8d308fd4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03c2575c53333d07fceabdaae5871a0da0270cbf8e3ed624cd18fab5e0a89e60"
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
