class Aichat < Formula
  desc "All-in-one AI-Powered CLI Chat & Copilot"
  homepage "https://github.com/sigoden/aichat"
  url "https://github.com/sigoden/aichat/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "94bc8b23b9c223e3a4191ec5c530fb4c26d5437f3a1a8ed895aa1e2f4dab49a2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sigoden/aichat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7731d9e2df906ce7920e5e4d0a473159fefb0880a2d80d7eef2d5ddadf8fc942"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61c592a493314a2486d89953f161e591d97765f342a64d6df4d248c4d4c56321"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acc652171d753efe7d714a937e44f103f832122b6d57eec184cb35dd4c5ebbc4"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca1f330a6752fa9c34e163c6f9201fff565415e062e605a74a74bb8aa96069aa"
    sha256 cellar: :any_skip_relocation, ventura:        "bd59ce7682aa1b39f3aec3665fa4e657390a286a6ff6223ed8be68e1b9c16d41"
    sha256 cellar: :any_skip_relocation, monterey:       "593d2464582d6723c0b90a67afbe6e3f750877baac2c49cd73cf72e12d20dd85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5227dd608efd5e52e18e4cc643a381b70c61d78674b8c79faeb7f2bbfaea172b"
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
