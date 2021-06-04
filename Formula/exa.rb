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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "caac7c603cded147f69fec0b64deb28017b747861cd6ec0f7aa1df9d6a1387e6"
    sha256 cellar: :any_skip_relocation, big_sur:       "c3bc35df4c4957502d687da38bb7b4cdf1c2239b35bfdddebe004f05081c246e"
    sha256 cellar: :any_skip_relocation, catalina:      "e1d7aae78877242d8b2678744940d4fcb56a393fd4d69b0290f7da54e08a8b2b"
    sha256 cellar: :any_skip_relocation, mojave:        "935794d2a1521fc3645f48eaec3035748cde91b183a23bb0c68b069f1187aae9"
  end

  depends_on "pandoc" => :build unless Hardware::CPU.arm?
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
