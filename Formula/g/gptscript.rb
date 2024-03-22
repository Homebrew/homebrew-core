class Gptscript < Formula
  desc "Develop LLM Apps in Natural Language"
  homepage "https://gptscript.ai"
  url "https://github.com/gptscript-ai/gptscript/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "e1eb88113ad22d27eb5aadf1738cb325f89b20e6f6d565cbec52a3542a616ba3"
  license "Apache-2.0"
  head "https://github.com/gptscript-ai/gptscript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6de6a0a686d93e84bc53fffde97483dd7b28f1d5b8b04df4769a83e574a925ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "487edab16bae516961f68d4ea3728130f963fd8b00d3dc204c1fa65f7686843d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78d14da590be3a331f72aae42401948d05991ad8e200367f5cd4b2be8c0f9d8d"
    sha256 cellar: :any_skip_relocation, sonoma:         "37aa1ab221762d9f9ece7fb1046ae8d1b03ac382399aa9c0dec1c8d55c94ba43"
    sha256 cellar: :any_skip_relocation, ventura:        "96774bc0962d7de593e58d401cfa84e50eac018bb3613a9c3a43c58208e3650a"
    sha256 cellar: :any_skip_relocation, monterey:       "87f698906ce4b850341e3546fad49503fcc890ac299e284cc00f8a59dd6a1cbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f37fd0915dceca94ab0500cc57d66801dd963eb5c55532573900ebf0ff818c22"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gptscript-ai/gptscript/pkg/version.Tag=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "examples"
  end

  test do
    ENV["OPENAI_API_KEY"] = "test"
    assert_match version.to_s, shell_output(bin/"gptscript -v")

    output = shell_output(bin/"gptscript #{pkgshare}/examples/bob.gpt 2>&1", 1)
    assert_match "Incorrect API key provided", output
  end
end
