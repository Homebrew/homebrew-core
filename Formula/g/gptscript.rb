class Gptscript < Formula
  desc "Develop LLM Apps in Natural Language"
  homepage "https://gptscript.ai"
  url "https://github.com/gptscript-ai/gptscript/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "305452f24c032d44839d4bf01254733224af0f4f7fb4ecd2814a523edc5b4b1a"
  license "Apache-2.0"
  head "https://github.com/gptscript-ai/gptscript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1abfa5c58559318d5e4db5e95864e9efe297452b955dd48cf89eeaded1ab9fbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10845ec23f2a81b8fa372505d0be07eb1e1b1be5cc1f4058b4e8984cafb173cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c48cf23ea9b2bdd5c681461f1094b38f8279f15a0ebe9a1b9ac99346e5ee7be9"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a45626e8a09e2772ca73fd9753dfb1237af7ba564d8eb86d325c1a4c1fd1ab7"
    sha256 cellar: :any_skip_relocation, ventura:        "b23fb91c9614be29b4a0663061919f78668cc6c85eb0255f099c4374a1846110"
    sha256 cellar: :any_skip_relocation, monterey:       "0d63d512a7f4e2da0c2164caa2c6c3575f3253adf1ebf9e7401fad011ce5e9d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be54268dbd1b26d031c1184752dd61c33919df8041ba8fb13bda75a1b273cbbc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gptscript-ai/gptscript/pkg/version.Tag=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    pkgshare.install "examples"
  end

  test do
    ENV["OPENAI_API_KEY"] = "test"
    assert_match version.to_s, shell_output(bin/"gptscript -v")

    output = shell_output(bin/"gptscript #{pkgshare}/examples/bob.gpt 2>&1", 1)
    assert_match "Incorrect API key provided", output
  end
end
