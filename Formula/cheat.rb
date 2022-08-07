class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/refs/tags/4.3.0.tar.gz"
  sha256 "1e5bbaeca1bd3406afb03d696bd5e250189b4e11574c0077554150c2f054b8ce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72a6721c88acfc0b3344dd4538d7963c2d859b20f2be67a212acd5d9130a799a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44c3ce0b7bc370c101d04836702bc920990e859e6e8109f5971fbe0af2924ec7"
    sha256 cellar: :any_skip_relocation, monterey:       "0e6d1f2f5803148147c38ad0b7b3c49517bd18c20e6e83b9e61d712fc4c0a97e"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a16380bb57777a3d852abfa1928266684095c3b383c0f403126fb37c35d0797"
    sha256 cellar: :any_skip_relocation, catalina:       "c4a9463f1224b0df401ea5b57d2b30b612b3ac66023fc32d63ba883e5fc9c93a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8adf4edc75a5eb24f7c1e477464a9e04951e567c892ad6fd683eda9737a012ee"
  end

  depends_on "go" => :build

  conflicts_with "bash-snippets", because: "both install a `cheat` executable"

  def install
    system "go", "build", "-mod", "vendor", "-o", bin/"cheat", "./cmd/cheat"

    bash_completion.install "scripts/cheat.bash"
    fish_completion.install "scripts/cheat.fish"
    zsh_completion.install "scripts/cheat.zsh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cheat --version")

    output = shell_output("#{bin}/cheat --init 2>&1")
    assert_match "editor: vim", output
  end
end
