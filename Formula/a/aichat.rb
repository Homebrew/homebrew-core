class Aichat < Formula
  desc "All-in-one AI-Powered CLI Chat & Copilot"
  homepage "https://github.com/sigoden/aichat"
  url "https://github.com/sigoden/aichat/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "e194cc89afc213a6e3169738221cae641c347421c4f2aacd5d6f4f7cc6edb387"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sigoden/aichat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb51a984d400d6c62b6978a9d9c1e13c5d3837d9d2aef4f1d838a03d5b127f3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1b2c49651e762004cdc4851d8397d8b5677cc0b804e67486bd35a8c7de99507"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da41c83eaba9327bf0ff11f2c7809905365e1d74743c9127cb2e6a3df86f660b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b003b5f94382d23b8dc1a44831a109372324c59f79f21dae668af357b3a7230"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a3a2bb10971377b15727ca4fc7c2ba8eb905ef9034cfda97d58fff594e2b34a"
    sha256 cellar: :any_skip_relocation, ventura:       "1a636cf9b9e2bb24f2ee609400f204e6086f573a42e0fdab7809e0f305016978"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b3072ceed89d9206141fad174bdc04ca249f905917d2d6ddefd4fa00cc0d38e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dab29ef575f4af6926cba9b71dca94143c3363021c402262a1f1ad5a66af5dad"
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
