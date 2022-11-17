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
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_monterey: "621d5ce8d5e8f9841a6191e3246fda50ca4d98fb3a108969157293e4454baa21"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97b6bf5ce5591c1dc5c320ac857c3d977caf2547579d0d9145655ad9c2d9e255"
    sha256 cellar: :any_skip_relocation, ventura:        "147163a28ff48a30792fef4fb3566f7fa2d1bb59b85cf84b84ac784026115287"
    sha256 cellar: :any_skip_relocation, monterey:       "269e359b76de3e1084ccf276342a134cc752737bb5a83a6178b019940d0270f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b6b6a3c852c14ee92aa8c601cf0b81b79fe7be1f14d84e2fa0a21ead58fdeb1"
    sha256 cellar: :any_skip_relocation, catalina:       "d021fd5bc69c223104b5bebc176d9212074cb24154f37d54125d81bfdb847b44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd62a17077ea9a775ae6b83f9a574e165ddc9a59a32e2e3a0dfd5d1802514989"
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
