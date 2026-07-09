class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.455.tar.gz"
  sha256 "5bd7130d565b9b5a071ad765ab7a8307e8a2bd046b0268422dd0d66a88c4654f"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2598db9a3a91cb31acbf98c6e40e889aa112b81a2c3853a8ce1b0a4d633cef19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2598db9a3a91cb31acbf98c6e40e889aa112b81a2c3853a8ce1b0a4d633cef19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2598db9a3a91cb31acbf98c6e40e889aa112b81a2c3853a8ce1b0a4d633cef19"
    sha256 cellar: :any_skip_relocation, sonoma:        "967c4f1f0eb69c7a3fd28303fdcbfabfa63cd5bfed39989a55f5e23074e2a4a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6632d4ac08c4c614caada8f3ae197e1dadded238b5a849153f585831beb545b3"
    sha256 cellar: :any,                 x86_64_linux:  "a2d9ed716dc353dde9d815ababb5fc1caa742dfed59c6df4f4b6eed7b9f1268b"
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
