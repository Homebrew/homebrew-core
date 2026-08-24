class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/5.0.tar.gz"
  sha256 "04f23071b02580b474593b6f3509d9734761dfda23d978eca2e2c9f460a2e1e4"
  license "MIT"
  head "https://github.com/bensadeh/circumflex.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52a406985c13e74222f443df5ec3dd2a471e073cee561e64986931aa022cdc86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a6d9e1430cec0541cadf8a4ca9bc82a8d26a1921f5d4d9ef0760ef6f5f215f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3a0449698f6bee22c2594afa927764c244f6fe249ca7e6b9947c51862acc1a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "e82108bea310080d50c8fce7a282296fc686108e796406561f3ddce461c1a78d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "248b94fb84b73b09350e1310edec1d6e1ac8a1181a45c77cb592cbe4f73b6026"
    sha256 cellar: :any,                 x86_64_linux:  "86dedca1fdb828ad049ffd3414da5c4505bcaaf14d8dc5bb4ac220e3e6a53666"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"clx"), "./cmd/clx"
    man1.install "share/man/clx.1"
    bash_completion.install "share/completions/clx.bash" => "clx"
    zsh_completion.install  "share/completions/_clx"     => "_clx"
    fish_completion.install "share/completions/clx.fish"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath/".config"
    config_home = testpath/".config"

    assert_match "Item added to favorites", shell_output("#{bin}/clx add 1")
    assert_path_exists config_home/"circumflex/favorites.toml"
  end
end
