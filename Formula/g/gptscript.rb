class Gptscript < Formula
  desc "Develop LLM Apps in Natural Language"
  homepage "https://docs.gptscript.ai/"
  url "https://github.com/gptscript-ai/gptscript/archive/refs/tags/v0.9.7.tar.gz"
  sha256 "d5c5d6d5acde988bc47a6566b2cc5b87e3fea2fa9112cd6ce3b6534405646a20"
  license "Apache-2.0"
  head "https://github.com/gptscript-ai/gptscript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c07b26c14d5743725320bc0278e538ec58f6be02f43cddcf8ade03bff290fcf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c07b26c14d5743725320bc0278e538ec58f6be02f43cddcf8ade03bff290fcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c07b26c14d5743725320bc0278e538ec58f6be02f43cddcf8ade03bff290fcf"
    sha256 cellar: :any_skip_relocation, sonoma:        "579c7c3e34bef2d478e764e2aaf5d63b4c6e5bbbbc15798a0582a5f0dace897a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cb2cff551ce0f291592f83cb3dbf28d52c6e041a75ab585f8ed648e27e2d65b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "549dac1f76d4938b6bde125cfd16157eca990725c5a00441215cdf36b9d70394"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gptscript-ai/gptscript/pkg/version.Tag=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "examples"
    generate_completions_from_executable(bin/"gptscript", "completion")
  end

  test do
    ENV["OPENAI_API_KEY"] = "test"
    assert_match version.to_s, shell_output("#{bin}/gptscript -v")

    output = shell_output("#{bin}/gptscript #{pkgshare}/examples/bob.gpt 2>&1", 1)
    assert_match "Incorrect API key provided", output
  end
end
