class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.3.1.3",
      revision: "0013bf8c7451a3658ea153a593ff322e8750a29f"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61e46c849d5cbfe9f5a9c21a6b0a4dc025c66c649eda45e07b963bc642202fcd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61e46c849d5cbfe9f5a9c21a6b0a4dc025c66c649eda45e07b963bc642202fcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61e46c849d5cbfe9f5a9c21a6b0a4dc025c66c649eda45e07b963bc642202fcd"
    sha256 cellar: :any_skip_relocation, sonoma:        "e39b03c987d1f427d41f2e2edb04e058026c5782089d35bce9643fb89b6c6622"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d2a96048e110b21305fb857f5bb63ebf239fa0e062a7003f9dde78c0b4dd100"
    sha256 cellar: :any,                 x86_64_linux:  "5da0e2ccba3e6b4d95c785c7e2e8e8fb456075aa59aad3e32575d52b35f4914b"
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
