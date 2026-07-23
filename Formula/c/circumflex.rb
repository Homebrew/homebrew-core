class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/4.5.tar.gz"
  sha256 "60a521e090027c501c3a2b8c3affbc32ae0a65161fa97e26a8f1b1ae750cec1d"
  license "MIT"
  head "https://github.com/bensadeh/circumflex.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1998c1dbe8891fe3f39b8928e430c1c6f09675946ebfed53c678bd08626c0cc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1998c1dbe8891fe3f39b8928e430c1c6f09675946ebfed53c678bd08626c0cc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1998c1dbe8891fe3f39b8928e430c1c6f09675946ebfed53c678bd08626c0cc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f31cd213faf774ba17543a7feef377b279e2268e7069fb3343cfad6f92fdf44c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d702e0a08003968eaa0af77434c38f9608840e99c65731247b13ba164485d314"
    sha256 cellar: :any,                 x86_64_linux:  "17d38f54b4adddc61cf860d2d035856946a36572d34f48fecab2fca9b4d8e770"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"clx", ldflags: "-s -w"), "./cmd/clx"
    man1.install "share/man/clx.1"
    bash_completion.install "share/completions/clx.bash" => "clx"
    zsh_completion.install  "share/completions/_clx"     => "_clx"
    fish_completion.install "share/completions/clx.fish"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath/".config"
    config_home = testpath/".config"

    assert_match "Item added to favorites", shell_output("#{bin}/clx add 1")
    assert_path_exists config_home/"circumflex/favorites.json"
  end
end
