class Gmailctl < Formula
  desc "Declarative configuration for Gmail filters"
  homepage "https://github.com/mbrt/gmailctl"
  url "https://github.com/mbrt/gmailctl/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "6a299e60cfd5e58a327d2768cb9ce791b87d2e8be5293d29a4f4919d00cca2cf"
  license "MIT"
  head "https://github.com/mbrt/gmailctl.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77a704db92814c882fce2b066e26b8fe91545a9a5769047b6d087f5305d78fc3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77a704db92814c882fce2b066e26b8fe91545a9a5769047b6d087f5305d78fc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77a704db92814c882fce2b066e26b8fe91545a9a5769047b6d087f5305d78fc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "73a83c86b05cc2160d9f5ace393e223834eca4246bd8d4e3d3e2c700137f9dff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5702da40d84a0a374fbcdd6232f1c93654938b0ce81cec90bce2fd2adccb50f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ec77775a68bc9a7448687bab9cff015b8bed71079474eac17212bb4b54d8c00"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "cmd/gmailctl/main.go"

    generate_completions_from_executable(bin/"gmailctl", shell_parameter_format: :cobra)
  end

  test do
    assert_includes shell_output("#{bin}/gmailctl init --config #{testpath} 2>&1", 1),
      "The credentials are not initialized"

    assert_match version.to_s, shell_output("#{bin}/gmailctl version")
  end
end
