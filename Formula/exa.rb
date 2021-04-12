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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "17c9a2d3b8dfbe891e75273cc5168c8aaf2637ce5dfa8e4eea8597f87444ccaa"
    sha256 cellar: :any_skip_relocation, big_sur:       "7eb1810c90baefdb929cc0da8c49c6c31c54c68edf6bc28e357294127a439506"
    sha256 cellar: :any_skip_relocation, catalina:      "b57beae48897bdc664fe487d97a5fd2117c898fd1c89903786ffd8214be42020"
    sha256 cellar: :any_skip_relocation, mojave:        "4d6c09c544afcf8fcebc9a18fbaef262e8da65de7c916ccfa5df8c5d55a764b6"
  end

  depends_on "pandoc" => :build unless Hardware::CPU.arm?
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "libgit2"
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/completions.bash" => "exa"
    zsh_completion.install  "completions/completions.zsh"  => "_exa"
    fish_completion.install "completions/completions.fish" => "exa.fish"

    args = %w[
      --standalone
      --to=man
    ]

    unless Hardware::CPU.arm?
      system "pandoc", *args, "man/exa.1.md", "-o", "exa.1"
      system "pandoc", *args, "man/exa_colors.5.md", "-o", "exa_colors.5"

      man1.install "exa.1"
      man5.install "exa_colors.5"
    end
  end

  test do
    (testpath/"test.txt").write("")
    assert_match "test.txt", shell_output("#{bin}/exa")
  end
end
