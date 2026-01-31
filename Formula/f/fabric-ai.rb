class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.397.tar.gz"
  sha256 "173ce911fa4eb0f4193e247300f895a25e4736bffd21ff7f6d23609ba1ea6326"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "624319cb17e26c3d6a1c66072dd0d2aa46bd7590ba46c100e56baef6595d60b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "624319cb17e26c3d6a1c66072dd0d2aa46bd7590ba46c100e56baef6595d60b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "624319cb17e26c3d6a1c66072dd0d2aa46bd7590ba46c100e56baef6595d60b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "03007da0a2817fda7d5b32708840c8e8ef7a5192eae67640dd16c18399db95b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b15a72e49f1f1ce2f16e70b2b69de69ff5b241e5d272fe2fa6d60b285c51916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e3c00484ddcde8e063706b2da1972607bb3a13e4a62ff8f22e0d895b1fd9602"
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
