class Aichat < Formula
  desc "All-in-one AI-Powered CLI Chat & Copilot"
  homepage "https://github.com/sigoden/aichat"
  url "https://github.com/sigoden/aichat/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "a0f108c7da9c361fd30c1c8ba386cb33b6f9861c90bab663bcd3bdc89c9f29c7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sigoden/aichat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eacf9842cb989f0ae90683756bd57ef34766a2b0b97d8119536a390bb4828eb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a94c1e934b03a2998d418f77b444b9130815a390e4eeac5f2abf2898c7eb15e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75205014faefb9a261021f8e07caa9d7c101e155dab4c56ad17df0d73355211b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b48787fead508e32989d2bf5e3dceba3de12b7e483d3f0808ca669b99b67199d"
    sha256 cellar: :any_skip_relocation, ventura:       "964c158291ca9dcf62b119eb8694cc259406fefd7757ef2963d35829ede1d2c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6be13bc0404398a2efdf279990feb6636ba3fb54a95a6a4fb5879b71a9bd730"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "scripts/completions/aichat.bash" => "aichat"
    fish_completion.install "scripts/completions/aichat.fish"
    zsh_completion.install "scripts/completions/aichat.zsh" => "_aichat"
  end

  test do
    ENV["AICHAT_PLATFORM"] = "openai"
    ENV["OPENAI_API_KEY"] = "sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    output = shell_output("#{bin}/aichat --dry-run math 3.2x4.8")
    assert_match "math 3.2x4.8", output
  end
end
