class Mcfly < Formula
  desc "Fly through your shell history"
  homepage "https://github.com/cantino/mcfly"
  url "https://github.com/cantino/mcfly/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "110b639b1c814a166faf205deb0714d96049f65c58bd9514189892484ebfd82b"
  license "MIT"
  head "https://github.com/cantino/mcfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ba27efc89435f4f387633c63e180fc76ea54b0e6fb15a245060c386e3801993"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "773ff043face25385c77335c193b247d30adffe64255b8cd4b4bfa13c0a88b1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29fc7d87244abf0f0365d3228c41d4c0eb34162ee644e8f48d6d0284a0ae985a"
    sha256 cellar: :any_skip_relocation, sonoma:         "04bd09c811440449640d7648a306d4357474afff0240f30566373edfed49532b"
    sha256 cellar: :any_skip_relocation, ventura:        "e6336c25494c0d0ae2dc81a1dc5e4bab01a759b8f46947db18465343e0d3f4d5"
    sha256 cellar: :any_skip_relocation, monterey:       "5065bc01f9d12d35f7de31648291705664ad57d74fdd2b2da2ef75ef647d9db4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d753b4266e5efd8f70c4ce6943a0eed6140ab3f7a389f82751b186273e92c7b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  def caveats
    <<~EOS
      ONE MORE STEP!

      If this is your first time installing mcfly, add the following to the end of your ~/.bashrc, ~/.zshrc, or ~/.config/fish/config.fish file:

      Bash:
        eval "$(mcfly init bash)"

      Zsh:
        eval "$(mcfly init zsh)"

      Fish:
        mcfly init fish | source

      You will also need to restart your terminal when first installing and on some updates. If you receive a McFly error when running commands, try restarting your terminal.
    EOS
  end

  test do
    assert_match "mcfly_prompt_command", shell_output("#{bin}/mcfly init bash")
    assert_match version.to_s, shell_output("#{bin}/mcfly --version")
  end
end
