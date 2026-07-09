class Gptscript < Formula
  desc "Develop LLM Apps in Natural Language"
  homepage "https://docs.gptscript.ai/"
  url "https://github.com/gptscript-ai/gptscript/archive/refs/tags/v0.9.9.tar.gz"
  sha256 "1f875ca3da55f1c2d697807a375dba517ad5f49a2b1115d22590b2bcd968548e"
  license "Apache-2.0"
  head "https://github.com/gptscript-ai/gptscript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bff15834f6a38946cdf73bee8b55efb58f3ed81f7a5374d3e80f22192b0ce49f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bff15834f6a38946cdf73bee8b55efb58f3ed81f7a5374d3e80f22192b0ce49f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bff15834f6a38946cdf73bee8b55efb58f3ed81f7a5374d3e80f22192b0ce49f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fadef1894aa8e23ed95daa279b410304eeaeeb2b95281a67632ef8d0c08e426b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5674b31456e0064de7508605782a1045b4fa345cbc214660611ecaf5130d0e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb2ba5fb7537abadb968090d3133b2ad1e026e66f096dff60eb20278d4fe7263"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gptscript-ai/gptscript/pkg/version.Tag=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "examples"
    generate_completions_from_executable(bin/"gptscript", shell_parameter_format: :cobra)
  end

  test do
    ENV["OPENAI_API_KEY"] = "test"
    assert_match version.to_s, shell_output("#{bin}/gptscript -v")

    output = shell_output("#{bin}/gptscript #{pkgshare}/examples/bob.gpt 2>&1", 1)
    assert_match "Incorrect API key provided", output
  end
end
