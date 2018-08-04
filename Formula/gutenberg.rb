class Gutenberg < Formula
  desc "Opinionated static site generator with everything built-in"
  homepage "https://www.getgutenberg.io/"
  url "https://github.com/Keats/gutenberg/archive/v0.4.0.tar.gz"
  sha256 "08fdadab70f1db96455f628006f8eeba76ba106f18d4f123c114706cac0e8302"
  head "https://github.com/Keats/gutenberg.git"

  bottle do
    sha256 "b59e0562bac25590b5259adb1259a8e8a6017abf93b52e593fc9c3f0380577dd" => :high_sierra
    sha256 "d3d4cb5b24b05be82b26737225db3fc41648887e956089eea0359aaa396d2f9a" => :sierra
    sha256 "f40c4ccdc3bcfa96367d86f00bc9fd6a390b069a2e22bdf23a0d32c465451833" => :el_capitan
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
