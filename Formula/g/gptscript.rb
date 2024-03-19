class Gptscript < Formula
  desc "Develop LLM Apps in Natural Language"
  homepage "https://gptscript.ai"
  url "https://github.com/gptscript-ai/gptscript/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "d13dadc5bea609e9e4fb927d1e51bda10e41771d572bb9a0bca93aaea08d77a6"
  license "Apache-2.0"
  head "https://github.com/gptscript-ai/gptscript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40c38009c64f3d682c12cf82fea4b086bc2c901bf9c55044f87a36096882b4f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96e75e8ce012517caccfdc7fb2d939e66cfdfd641c6d20057459fa4ccc975c77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e9e433da0ab92dacfc052c0fa84001a9c35dce9f67af988ddca4af2c31a9130"
    sha256 cellar: :any_skip_relocation, sonoma:         "a137b3786d330ca57c8759a189df7f3a4fef2eea38775ff431b5350010c52eb2"
    sha256 cellar: :any_skip_relocation, ventura:        "b19a0c9cbe35cbcf6dd2a53c682ba6f532c8a3481aa2cf8c90770e08df943526"
    sha256 cellar: :any_skip_relocation, monterey:       "487131f730d5c70f1ad9d166804bf6bccb899c9677ba523c48312f67e07c3be4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7765140022488c6ca1dc17ea3475d12767d8c97b167509a37e1d7b13c9f752f"
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
