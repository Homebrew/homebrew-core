class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.440.tar.gz"
  sha256 "6ef0dfd955fe2698b1f19c4cb8c4a053cb0350ebce40502a12d8db26421f2cc2"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b88654cd33399230c81eab24b19a93977460ef68a5558b0adb9c88ca7a475db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b88654cd33399230c81eab24b19a93977460ef68a5558b0adb9c88ca7a475db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b88654cd33399230c81eab24b19a93977460ef68a5558b0adb9c88ca7a475db"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c3c527670a4a299af3148a2da97c8cc565c31f8ce7cd5c1fc10f790b3e4e15b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cd76868873d11ccc9fb9ab54530c272c8c76a5a33fe598139653c4aa715d46b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ae61c681cf44fc5dfe54aee96d8383df7c72f1a1abe7337dac906671092a2b5"
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
