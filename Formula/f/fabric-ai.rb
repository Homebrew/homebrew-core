class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.330.tar.gz"
  sha256 "3771e9a030b49584d8a66e49ef38483ec9de1ee0595704c8df682c22d0b2b1ac"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9ffb68bd958a7eece378b62382d0eca6082e331228434160a08b7f8b8f3a81e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9ffb68bd958a7eece378b62382d0eca6082e331228434160a08b7f8b8f3a81e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9ffb68bd958a7eece378b62382d0eca6082e331228434160a08b7f8b8f3a81e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac587f79bc77c09f7e8060f9c29c00c8378dc6ffefbf495192f3baea78985b24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b116a67a5f43d8c847a3051957ba289f7efc011ad1faf90f81f8c0f13614c09f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "551ea3a5997271d39dd12d322c26fecf1a4363f42947e1ff0db15d4be33a6d13"
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
