class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.454.tar.gz"
  sha256 "96219b03f98edb111a04bbe3f19692cf1e28cf1aed588e4f5c61b6994b21791f"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70bd6349ebd13cf83fc0560fcf7b67fb21d0f62f38d6a4c22256e64205977a32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70bd6349ebd13cf83fc0560fcf7b67fb21d0f62f38d6a4c22256e64205977a32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70bd6349ebd13cf83fc0560fcf7b67fb21d0f62f38d6a4c22256e64205977a32"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ab32bb3b2f19614b285797286e9dc83f211943eb5d1bc196bc68348f82a8e62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9eb398b189809db5ba94e9c7bb396b14c9a925cf1a771a72acd9270c3b3f5d4"
    sha256 cellar: :any,                 x86_64_linux:  "23e1187fba4a1db8e8f8ce63d763071970e311ecfdcfacf5600cc1fbf9b5840d"
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
