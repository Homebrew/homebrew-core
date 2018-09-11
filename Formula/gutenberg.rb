class Gutenberg < Formula
  desc "Opinionated static site generator with everything built-in"
  homepage "https://www.getgutenberg.io/"
  url "https://github.com/Keats/gutenberg/archive/v0.4.2.tar.gz"
  sha256 "8d3fb9972a17f6fa8a7830c8d129a7d587f0bbfc36f5351dc4c9e44f46aa4e2d"
  head "https://github.com/Keats/gutenberg.git"

  bottle do
    sha256 "8be1ae1ef65b68d173283815af6d5a018d610cfd1ac6d225b493760d81d65a64" => :mojave
    sha256 "0b03919653820481e36c1749954f2bd555c0c511ca579e3f45078f811eb185ab" => :high_sierra
    sha256 "d63a11f8c299a9acc7231e9ac80855033a325a0b09b839c0064cab1f2b9d920b" => :sierra
    sha256 "4f0c0dbfe7ab3ee735dfc4a1327e13a81688a57934f5ddd3939880ac9bfb6f35" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."

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
