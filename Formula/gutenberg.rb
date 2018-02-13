class Gutenberg < Formula
  desc "Opinionated static site generator with everything built-in"
  homepage "https://www.getgutenberg.io/"
  url "https://github.com/Keats/gutenberg/archive/v0.3.0.tar.gz"
  sha256 "7d2f5607b1ded65166ac4e2b3336114d4eb5a9cd699da060f7f9aa58fc976ccb"
  head "https://github.com/Keats/gutenberg.git"

  bottle do
    sha256 "256fc2268b85e9a4860fc3f2493d3b4bff7d56db953d0e87fc237e251aa35b69" => :high_sierra
    sha256 "947e1c104d83033b06eac93ea11998b83e226cc5a77553221a486d8b26e0564a" => :sierra
    sha256 "4b83050cf1cdadbbf55efd78b8a932b18f66a435cf9bcb79df2b71221cfc17a1" => :el_capitan
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
