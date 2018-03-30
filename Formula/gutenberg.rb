class Gutenberg < Formula
  desc "Opinionated static site generator with everything built-in"
  homepage "https://www.getgutenberg.io/"
  url "https://github.com/Keats/gutenberg/archive/v0.3.3.tar.gz"
  sha256 "5652e370d3826b2a4dc5ad70f0a6e695748eb6c41c566fde0cef88ac93ccb221"
  head "https://github.com/Keats/gutenberg.git"

  bottle do
    sha256 "8aa962df393b235f4f00b46ab6c61dc6edfa3b82e1dc5a4ab58d08192c49c055" => :high_sierra
    sha256 "3a527a74464e28e6b59f927cd1af994895cfb5fca44cfe3176e44ff29e4f639c" => :sierra
    sha256 "afbc5c73a83c5a05eb96ec6df43c543cfd2ee8b5373caaab920e53b1a0513a21" => :el_capitan
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
