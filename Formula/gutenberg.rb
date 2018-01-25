class Gutenberg < Formula
  desc "Opinionated static site generator with everything built-in"
  homepage "https://www.getgutenberg.io/"
  url "https://github.com/Keats/gutenberg/archive/v0.3.0.tar.gz"
  sha256 "7d2f5607b1ded65166ac4e2b3336114d4eb5a9cd699da060f7f9aa58fc976ccb"
  head "https://github.com/Keats/gutenberg.git"

  bottle do
    sha256 "7f77f4e117416ed268649f1083a63bbff5c57d65e0e51f1f98941a00b0d0308d" => :high_sierra
    sha256 "93748ce4280114f597c14161551057fa8b0d0893dcdf466d990dd5bd134d7af6" => :sierra
    sha256 "32eccea3dbffec9e38a92d296d16f1dbfe6a3ccf545f23bac188c479b3c4892b" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"

    bin.install "target/release/gutenberg"
    bash_completion.install "completions/gutenberg.bash-completion"
    zsh_completion.install "completions/_gutenberg"
    fish_completion.install "completions/gutenberg.fish"
  end

  test do
    pipe_output("#{bin}/gutenberg init mysite", "\nn\nn\n", 0)
    (testpath/"mysite/content/blog/index.md").write <<~EOS
      +++
      +++

      Hi I'm Homebrew.
    EOS
    (testpath/"mysite/templates/page.html").write <<~EOS
      {{ page.content | safe }}
    EOS

    cd testpath/"mysite" do
      system bin/"gutenberg", "build"
    end

    assert_equal "<p>Hi I'm Homebrew.</p>",
      (testpath/"mysite/public/blog/index.html").read.strip
  end
end
