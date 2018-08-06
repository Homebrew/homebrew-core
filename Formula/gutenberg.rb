class Gutenberg < Formula
  desc "Opinionated static site generator with everything built-in"
  homepage "https://www.getgutenberg.io/"
  url "https://github.com/Keats/gutenberg/archive/v0.4.0.tar.gz"
  sha256 "08fdadab70f1db96455f628006f8eeba76ba106f18d4f123c114706cac0e8302"
  head "https://github.com/Keats/gutenberg.git"

  bottle do
    sha256 "16ee50009a9eb745c506ee72571376c23e7cfbb005f52f087b6f7345989d2f77" => :high_sierra
    sha256 "d27e07f05ab0233f0c45e7ea613e7aa467d6fb1cf50867932c03e09033232466" => :sierra
    sha256 "7e5e4767e544efa45bab46ad0de3710b2584c9c2c5b4f043135ebf5f5996089c" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix

    bash_completion.install "completions/gutenberg.bash-completion"
    zsh_completion.install "completions/_gutenberg"
    fish_completion.install "completions/gutenberg.fish"
  end

  test do
    system "yes '' | #{bin}/gutenberg init mysite"
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
