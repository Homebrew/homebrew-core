class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.460.tar.gz"
  sha256 "9058fa9cbf6a1cb166b50f67554bf79b532c6aa0c0908aa86593cc4080b1d894"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a82bd37eef94ca64416af366cf97df91e0139758f542db9b79f7b90e36adbd1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a82bd37eef94ca64416af366cf97df91e0139758f542db9b79f7b90e36adbd1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a82bd37eef94ca64416af366cf97df91e0139758f542db9b79f7b90e36adbd1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe2287b7fb3803651326bc9fb6e6c8bcdd10b7141bce7f28b29a8a5af3fdbbda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2313fc64f519d0960d10a6275e897afee290f32569ae74a6cdc87abc263f8746"
    sha256 cellar: :any,                 x86_64_linux:  "bcec4b0866dac6a6314db66d19c11c32438ebd2ed03be52f2f1a00c7c1768180"
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
