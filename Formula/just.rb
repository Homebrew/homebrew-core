class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/0.11.1.tar.gz"
  sha256 "b206e042c0a535b4435523e578c3c72cf87af62689cdfa0c3d0f1f2fe275ace1"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "067df96491ad0b271f6c1f28a033a8b80dbad835b5160959d4bb72f62f5f893c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "549a53d4ffde5c55bd0534233b10843f0ee15bf48e94be25feee216882223561"
    sha256 cellar: :any_skip_relocation, monterey:       "f571b74da3d072ccf81b1e3b126263bc7879616ce716d9bb4764c7831ce66b2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a4763041559ff7f03825bbffea80e4dec96be20dda1ba28ec9fe0f100df4df1"
    sha256 cellar: :any_skip_relocation, catalina:       "929467b6b0ab40621cd9adbaa0c3e8272b66584ab5e9e15c5290db103074b89c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc91c377df6d5f8c012225ffaf5b91bfb1b5c480b443cbfc3577b8571ac213f5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "man/just.1"
    bash_completion.install "completions/just.bash" => "just"
    fish_completion.install "completions/just.fish"
    zsh_completion.install "completions/just.zsh" => "_just"
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin/"just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
