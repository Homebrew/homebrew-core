class Llmdog < Formula
  desc "Prepare files for LLM consumption"
  homepage "https://github.com/doganarif/llmdog"
  url "https://github.com/doganarif/llmdog/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "532bb4a1db5143c9c4fa61728184a0af0c9f47b56387453239b0b9b820a41079"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/llmdog"
  end

  test do
    assert_match "llmdog version", shell_output("#{bin}/llmdog --version")
  end
end
