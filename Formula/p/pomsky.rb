class Pomsky < Formula
  desc "Regular expression language"
  homepage "https://pomsky-lang.org/"
  url "https://github.com/pomsky-lang/pomsky/archive/refs/tags/v0.12.tar.gz"
  sha256 "a6265bac4e9ddb03f85ddb9a9c2cc391472b8b0d14570719146272fd3cf361d3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/pomsky-lang/pomsky.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71e19e3cca23e38bcdb532dde14d23f0312b76d3c19b46cddd1d2e20bb9f8605"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2d70c94772a5598e3144532228ecb3b36cb81c94a8b71c62d053635a82f23b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a74457171151082723e10444c88b199e7575ebed4527dda3f8620158afe98790"
    sha256 cellar: :any_skip_relocation, sonoma:        "84a2d065348e9ee0e23b3b884ab91cf38cf252787fb2f772c073604341301deb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9db6c902bd7b09bdd3664d9c811c51dae45dd3296c353449ec49e4411a36cac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "642b05dd4cde8501631e0bdccdb648017b0f17eedd7d468feaa03f1a55f8ff6b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "pomsky-bin")

    bash_completion.install "completions/pomsky.bash" => "pomsky"
    fish_completion.install "completions/pomsky.fish"
    zsh_completion.install "completions/pomsky.zsh" => "_pomsky"
  end

  test do
    assert_match "Backslash escapes are not supported",
      shell_output("#{bin}/pomsky \"'Hello world'* \\X+\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/pomsky --version")
  end
end
