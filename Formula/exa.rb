class Exa < Formula
  desc "Modern replacement for 'ls'"
  homepage "https://the.exa.website"
  url "https://github.com/ogham/exa/archive/v0.10.1.tar.gz"
  sha256 "ff0fa0bfc4edef8bdbbb3cabe6fdbd5481a71abbbcc2159f402dea515353ae7c"
  license "MIT"
  head "https://github.com/ogham/exa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d39fb8905caae1b7b0f998960b7ed2fed3f758499acdab52b7a68acb6ed06f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d60f5270bfc6f8fcf6729d86bcf994e5cdf582761711c67170dd990c4951e728"
    sha256 cellar: :any_skip_relocation, monterey:       "3fe9b4a21d636e1282df9f2d9d29ac785af5ecd10bf3a2a584eebb57976b8311"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd1eb7bc9000217571a70b5c745befe6e471cca27374b0035557fe6afe3e73dd"
    sha256 cellar: :any_skip_relocation, catalina:       "5400719f606f276a1e421685881919adbda04028cead1b8c64b1b342c201fb9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7f44f39c1beea749b9dd4373954a080381c0f0f01d8e987e8f21ac87e269155"
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
