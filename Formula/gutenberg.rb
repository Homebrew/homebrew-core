class Gutenberg < Formula
  desc "Opinionated static site generator with everything built-in"
  homepage "https://www.getgutenberg.io/"
  url "https://github.com/Keats/gutenberg/archive/v0.3.2.tar.gz"
  sha256 "0424a1dff5050c765ae7a55ee7f944de4f7f2562ea816c1219223fa7eb5f948c"
  head "https://github.com/Keats/gutenberg.git"

  bottle do
    sha256 "8a1d27b1af2514d07d3201be1520bddc487c57965df2305cc896771f41479b79" => :high_sierra
    sha256 "2a30489509edacdf70a15055d9a08a8cc670da107fc55c4acdaddb0066f9457d" => :sierra
    sha256 "46408add4d4070325f9a7a3f0c2601ff376a2e2e9a540ea27bc328cdfa91795b" => :el_capitan
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
