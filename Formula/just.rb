class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.8.6.tar.gz"
  sha256 "82b704c3e5309e4f0e8005bf42c60004b9bc5c243bba3031841418f7935b8a45"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a39b3a4b2b0d742d66a4bece9ed38ec178f3740f645a2682966cf66471799f63"
    sha256 cellar: :any_skip_relocation, big_sur:       "85b4ac007a97d2654761e2e7aacbf6433d763e65a9a8f2b46f2dff3f8166e9b5"
    sha256 cellar: :any_skip_relocation, catalina:      "2128a6050652de4c87b97b7d4194b9bfbe063cbaaa823640d2b4c778e98266fd"
    sha256 cellar: :any_skip_relocation, mojave:        "5d2656cdbf62c300cfdf147d1aac16b45edc49a8fc613ad35ab0501ad11cfd34"
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
    system "#{bin}/just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
