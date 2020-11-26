class Exa < Formula
  desc "Modern replacement for 'ls'"
  homepage "https://the.exa.website"
  url "https://github.com/ogham/exa/archive/v0.9.0.tar.gz"
  sha256 "96e743ffac0512a278de9ca3277183536ee8b691a46ff200ec27e28108fef783"
  license "MIT"
  revision 1

  livecheck do
    url "https://github.com/ogham/exa/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 4
    sha256 "3f7b47cd10cce1ab2e51f59d0b3bea05153b5027e4541091e0eeeb5510f585db" => :big_sur
    sha256 "b0c1b9366cb7c6753a9e8467b5fe1e4dcbc3e148df59b5d79bcd8b8814c30443" => :catalina
    sha256 "2770559fa1082afeb6755a38ed8b5c2f72b7e88e41132caec9c2a22b7164ef69" => :mojave
    sha256 "f93d7eaeeffbf42a471aaec0d466767187f47fa68d25e0cb448763ee169d30c9" => :high_sierra
  end

  head do
    url "https://github.com/ogham/exa.git"
    depends_on "pandoc" => :build
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "libgit2"
  end

  def install
    system "cargo", "install", *std_cargo_args

    # Remove in 0.9+
    if build.head?
      bash_completion.install "completions/completions.bash" => "exa"
      zsh_completion.install  "completions/completions.zsh"  => "_exa"
      fish_completion.install "completions/completions.fish" => "exa.fish"

      args = %w[
        --standalone
        --to=man
      ]

      system "pandoc", *args, "man/exa.1.md", "-o", "exa.1"
      system "pandoc", *args, "man/exa_colors.5.md", "-o", "exa_colors.5"

      man1.install "exa.1"
      man5.install "exa_colors.5"
    else
      bash_completion.install "contrib/completions.bash" => "exa"
      zsh_completion.install  "contrib/completions.zsh"  => "_exa"
      fish_completion.install "contrib/completions.fish" => "exa.fish"
      man1.install "contrib/man/exa.1"
    end
  end

  test do
    (testpath/"test.txt").write("")
    assert_match "test.txt", shell_output("#{bin}/exa")
  end
end
