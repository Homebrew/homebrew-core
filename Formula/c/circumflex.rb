class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/4.4.tar.gz"
  sha256 "ea0d29d95a8999d32a592d68484a7acd2dc2651da3ecbe49cbfab43038c9b68d"
  license "MIT"
  head "https://github.com/bensadeh/circumflex.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a0353cc5a3f737cc11b295e306d2d1a39ec3c57a5835e9fae60bb2627a2f582"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a0353cc5a3f737cc11b295e306d2d1a39ec3c57a5835e9fae60bb2627a2f582"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a0353cc5a3f737cc11b295e306d2d1a39ec3c57a5835e9fae60bb2627a2f582"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0f709f076cbe6af7966de2d852dd6ef4376fa8c55541aee884b4fd0f79924f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0eb04c6fc0e554c4c0541b2d9743ca29672ab79121b31d86622bd271c4f5a2d"
    sha256 cellar: :any,                 x86_64_linux:  "24a00d610fe5a08ec6232c280a4f30f2794b27bbf752f6b1f7e9aba8d54a34ae"
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
