class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.565.tar.gz"
  sha256 "6bff079a10999cdc752d856bfdfad3883ad48f8d0bf56addc93e19dc8fdbacb4"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a608741cf00a8f9620452a64ad883e06387ad23c6eebb37371a4f896caba09f6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a608741cf00a8f9620452a64ad883e06387ad23c6eebb37371a4f896caba09f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a608741cf00a8f9620452a64ad883e06387ad23c6eebb37371a4f896caba09f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "58057883d081bcf2e39d18824d1b11cdc7b2925ce49992095748450bd32482ba"
    sha256 cellar: :any,                 x86_64_linux:      "c79146e9e56f9f21ee24a1da5f69ddd18cf362bb10f7614c98328c72ada86435"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/fabric"
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
