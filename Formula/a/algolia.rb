class Algolia < Formula
  desc "CLI for Algolia"
  homepage "https://www.algolia.com/doc/tools/cli/get-started"
  url "https://github.com/algolia/cli/archive/refs/tags/v1.10.5.tar.gz"
  sha256 "7ed6d5cb2d04236de207dc801637819ce543d24cc372b32246ed6a2847d83092"
  license "MIT"
  head "https://github.com/algolia/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcd7caf227127bd43ba9ce604db94757abfc8d6fcb38394bb51ea22607668989"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcd7caf227127bd43ba9ce604db94757abfc8d6fcb38394bb51ea22607668989"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcd7caf227127bd43ba9ce604db94757abfc8d6fcb38394bb51ea22607668989"
    sha256 cellar: :any_skip_relocation, sonoma:        "75b048600c13d67f34154032c7db613b7666acc01498e0b423fdffe828919ce2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0df1a9fc5aee8a5db030883311ea88e64879cb64de11157e43a5663d6d683bf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9779164b162e810ca54a473af10ef8fb147a74b7df6598e92945b263477d06c5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/algolia/cli/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/algolia"

    generate_completions_from_executable(bin/"algolia", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/algolia --version")

    output = shell_output("#{bin}/algolia apikeys list 2>&1", 4)
    assert_match "you have not configured your Application ID yet", output
  end
end
