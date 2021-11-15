class Exa < Formula
  desc "Modern replacement for 'ls'"
  homepage "https://the.exa.website"
  url "https://github.com/ogham/exa/archive/v0.10.1.tar.gz"
  sha256 "ff0fa0bfc4edef8bdbbb3cabe6fdbd5481a71abbbcc2159f402dea515353ae7c"
  license "MIT"
  head "https://github.com/ogham/exa.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d0565b8b078c0af60f359c273f8fb2b5bd4832f66f9ba2cce6ac1e6a3a6782c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b9cc70621644245ce1ab1b682e28efae4b8acdbf3bf4da9cf91ddbd786b8787"
    sha256 cellar: :any_skip_relocation, monterey:       "116ebfabdd5f5a06725dcd563c1bb05f723b3543f5204985a3f7dc7089a5d765"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0c809ae7a8d3a43e0c907854b46725f5ad6bb14fa40a9857ff4e74f15c0b961"
    sha256 cellar: :any_skip_relocation, catalina:       "dc183942b94bac912f4e0a6ca5c8859fa755a95de2808bd978dde3911690f0ae"
    sha256 cellar: :any_skip_relocation, mojave:         "62fac977958ef8a9856e7a28fceac53d4f6e327e11764d1a077fb34ac83aced0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fad8013ab85b04c039c1b1be716bd621370dfcf810e3eb714e53711701b9aa45"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "libgit2"
  end

  def install
    system "cargo", "install", *std_cargo_args

    if build.head?
      bash_completion.install "completions/bash/exa"
      zsh_completion.install  "completions/zsh/_exa"
      fish_completion.install "completions/fish/exa.fish"
    else
      # Remove after >0.10.1 build
      bash_completion.install "completions/completions.bash" => "exa"
      zsh_completion.install  "completions/completions.zsh"  => "_exa"
      fish_completion.install "completions/completions.fish" => "exa.fish"
    end

    args = %w[
      --standalone
      --to=man
    ]
    system "pandoc", *args, "man/exa.1.md", "-o", "exa.1"
    system "pandoc", *args, "man/exa_colors.5.md", "-o", "exa_colors.5"
    man1.install "exa.1"
    man5.install "exa_colors.5"
  end

  test do
    (testpath/"test.txt").write("")
    assert_match "test.txt", shell_output("#{bin}/exa")
  end
end
