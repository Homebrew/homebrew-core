class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.336.tar.gz"
  sha256 "0fb2cc7d4913e2e7cd265053b5162cc745e578e43088075ffdd9470c89aa3e0c"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2715d2ba46579289008e5e13d80e2f99ddcb016125abc4c1b1310eeae40d11b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2715d2ba46579289008e5e13d80e2f99ddcb016125abc4c1b1310eeae40d11b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2715d2ba46579289008e5e13d80e2f99ddcb016125abc4c1b1310eeae40d11b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "a35a5fcda0fbd1d9bce05b793ed418c1b2167a071babaa086e37e8ba05240d22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2149186a12ecb4406319372f9a05dd64bfbef08e13a7b9403431614dde0f59ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b16321655f2ed64cbc9335ff398213398a1f927fcd3a4652e7ab1555f062c483"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fabric"
    # Install completions
    bash_completion.install "completions/fabric.bash" => "fabric-ai"
    fish_completion.install "completions/fabric.fish" => "fabric-ai.fish"
    zsh_completion.install "completions/_fabric" => "_fabric-ai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end
