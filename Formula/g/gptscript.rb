class Gptscript < Formula
  desc "Develop LLM Apps in Natural Language"
  homepage "https://gptscript.ai"
  url "https://github.com/gptscript-ai/gptscript/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "f940dd66f2f546ce3c2be85cdea222d6b0b897154745ed11c1d3b3b35e4f4757"
  license "Apache-2.0"
  head "https://github.com/gptscript-ai/gptscript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3cbc137d673a5babd13a3efff9cf2a484e3cd1b5b6b870dfae0b8e88397edb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4f2dbad7aad99f9d61d69fc9009e7c28ebd0709b5a249483c428ef99d778ce0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "561ca87fcb89d9d84cb72b3f9478522713084a3feeb4dbdd2fda10d225ce27a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "cdfc99ab16edb300e71e66a641ae453c3003c161267c8fb6aff1e63e0da1e4ff"
    sha256 cellar: :any_skip_relocation, ventura:        "9bb8ee7adcbf16faa0d983621f4c94c0a4c8213d21ddd047370a442622f8cf2e"
    sha256 cellar: :any_skip_relocation, monterey:       "d9755b3a19807684f43e97836a4a3f826620a2b1bf117ded590e0944d713734e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19b45990fd86ac605018ab849e08e5aef9e612872d81a11763eed91740c75dbe"
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
