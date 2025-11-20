class Mods < Formula
  desc "AI on the command-line"
  homepage "https://github.com/charmbracelet/mods"
  url "https://github.com/charmbracelet/mods/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "e16268ce55b9c90395116c2c8ce4d820d18d7f0b05430d64dc69686410776231"
  license "MIT"
  head "https://github.com/charmbracelet/mods.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0ace82772dbc9bd679b85ea474a84ceee99e61dbedcf0cebbb400f0ab5fe3ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "679478d8a2130c41981b35df3755dc526696b284912031d86dc09f75db788fee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "679478d8a2130c41981b35df3755dc526696b284912031d86dc09f75db788fee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "679478d8a2130c41981b35df3755dc526696b284912031d86dc09f75db788fee"
    sha256 cellar: :any_skip_relocation, sonoma:        "75cacca99fb5c70b31d0b59fb23ba8572fa49d8f995cd3d666c3fdd37ae4d0fd"
    sha256 cellar: :any_skip_relocation, ventura:       "75cacca99fb5c70b31d0b59fb23ba8572fa49d8f995cd3d666c3fdd37ae4d0fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e5dba892702bd9cb1c41639be0e9e382c229604653aeb34d86bf6f81f7973d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e5dd968e08dfe368e4f6e098671a827afe2904be869cea0499d9ec25e562cde"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.CommitSHA=#{tap.user} -X main.CommitDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mods", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    output = pipe_output("#{bin}/mods 2>&1", "Hello, Homebrew!", 1)
    assert_match "ERROR  OpenAI authentication failed", output

    assert_match version.to_s, shell_output("#{bin}/mods --version")
    assert_match "GPT on the command line", shell_output("#{bin}/mods --help")
  end
end
