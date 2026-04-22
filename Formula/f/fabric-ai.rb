class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.448.tar.gz"
  sha256 "5ed067969ce20b65a4df75c9cdd7dade27dce134ab0001094521ab62a15a91ec"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71ef75989bccbed53add3914f89e6e8c90a4a5f6702c3aa719ab020ea2fd825c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71ef75989bccbed53add3914f89e6e8c90a4a5f6702c3aa719ab020ea2fd825c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71ef75989bccbed53add3914f89e6e8c90a4a5f6702c3aa719ab020ea2fd825c"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd613b5f98d5b2cd09d7b7886ba1799dc86f8105adb95afea470a59e63232a85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8dc3e69ee4917687a9d8add467e2f2c400e8387602c230186f95822714ebe65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "123ac27efb5f649a2e1360fbc558699fcbb42f5b2e0306aef05e4ae73cdd206b"
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
