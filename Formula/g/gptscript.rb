class Gptscript < Formula
  desc "Develop LLM Apps in Natural Language"
  homepage "https://gptscript.ai"
  url "https://github.com/gptscript-ai/gptscript/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "277638f7474769e2467f0bba6b779bff44830737bf828de535c3958ef2d2b2e3"
  license "Apache-2.0"
  head "https://github.com/gptscript-ai/gptscript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "75e14b847143cbe565b0aaf49fa0bf07a9130dd2472f173bfd38d2b63b5ab868"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fd6252e01dac9a2c4b4d995c40f07415b728fff074a1cca38da52ae21b76077"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "713c5778445ddabebccc99f600f1c319bbca61fca35efb530e13278273b776de"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c6d6b755c47a53d2a17e1e48af77de889c43df229414a1c8a795ef70364d4e6"
    sha256 cellar: :any_skip_relocation, ventura:        "69581245aeec025f0b428ab14092a2c1b379a14fb962f0bd0ed122c429a782b3"
    sha256 cellar: :any_skip_relocation, monterey:       "98f0569f374c3335596fc2edd65e97cf692d67d1cc14330d6bf9bf1becbc63fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fd1b0bb9b53921d8c61a683ddaa6f7a81a0808b007cbac8f9714626056ac256"
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
