class Exa < Formula
  desc "Modern replacement for 'ls'"
  homepage "https://the.exa.website"
  url "https://github.com/ogham/exa/archive/v0.10.0.tar.gz"
  sha256 "27420f7b805941988399d63f388be4f6077eee94a505bf01c2fb0e7d15cbf78d"
  license "MIT"
  head "https://github.com/ogham/exa.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b5fc2d5300cbd6ab2d3c113ce011c6ac187e8e774f3d3e4d1f1592b109206d39"
    sha256 cellar: :any_skip_relocation, big_sur:       "2ea88382cf3e9906bc27cd37f3f57c953cce9fcd686d958824ccb27093c5c8da"
    sha256 cellar: :any_skip_relocation, catalina:      "979193384c57b8858b592d1200468cb6584ffa7df7833d6777eb8637e0ecfc97"
    sha256 cellar: :any_skip_relocation, mojave:        "af7d2f089dc99cab221dbc57c33c443e112a843911d561588621e60378f56a46"
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
