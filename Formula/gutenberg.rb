class Gutenberg < Formula
  desc "Opinionated static site generator with everything built-in"
  homepage "https://www.getgutenberg.io/"
  url "https://github.com/Keats/gutenberg/archive/v0.2.2.tar.gz"
  sha256 "6ae747e791c96591bc8d3b41b1609ce53d06ad384c7db3c96875b5f8f049f72f"
  head "https://github.com/Keats/gutenberg.git"

  bottle do
    sha256 "4ea2becfbc50d6a9b3f925f0cc8fd4e91560f4c997577c558de0be52413d7f32" => :high_sierra
    sha256 "5b3ac8f7f1d77da03c2a5e80d7b544f95b490f2b2415de992264992d92182f3c" => :sierra
    sha256 "71b50c921bc8e0bbaa01c263577dfb0c3e15421d447082bc21673f3bd6591a6a" => :el_capitan
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
