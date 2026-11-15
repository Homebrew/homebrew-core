class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/5.1.tar.gz"
  sha256 "2e978f57b426ff7c5fc0fedf7e510f9669da9a3886cb54a29f2bd846d4a04a06"
  license "MIT"
  head "https://github.com/bensadeh/circumflex.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "663967727e8598c5328297256bf75c8e9a4f24adfba6d8a5f86d1e213a8aa4b5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "19dfc7ba1ebdba82d46b8df12a6d674fe3255df05a2117f801c76fe1936c4717"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "079be006d0074cee8a247fe5343e2ce17fc182b2152accb00387755b68b778b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d287afee8d1be20722e28ad3e719d19e062af3e666c4d2debf1da506bc028ed7"
    sha256 cellar: :any,                 x86_64_linux:      "2a47a942e4579f8e3888cad35ef7c47787f1535e01cc366a2fb107220e912b40"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
