class Gutenberg < Formula
  desc "Opinionated static site generator with everything built-in"
  homepage "https://www.getgutenberg.io/"
  url "https://github.com/Keats/gutenberg/archive/v0.3.3.tar.gz"
  sha256 "5652e370d3826b2a4dc5ad70f0a6e695748eb6c41c566fde0cef88ac93ccb221"
  head "https://github.com/Keats/gutenberg.git"

  bottle do
    sha256 "d5936e84a4c873e63a7860ab7ad39c3f0619acb9997162770c4a575bf19d35d6" => :high_sierra
    sha256 "506307c2f25e81039bd3568d5e7b1ca8f840a5189a74dad8d21330aac408fffb" => :sierra
    sha256 "2fd5988c2ce2c9426cad1d3da33e9475929dc6ee48260651fc783da7d781f9d5" => :el_capitan
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
