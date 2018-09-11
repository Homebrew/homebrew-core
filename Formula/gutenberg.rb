class Gutenberg < Formula
  desc "Opinionated static site generator with everything built-in"
  homepage "https://www.getgutenberg.io/"
  url "https://github.com/Keats/gutenberg/archive/v0.4.2.tar.gz"
  sha256 "8d3fb9972a17f6fa8a7830c8d129a7d587f0bbfc36f5351dc4c9e44f46aa4e2d"
  head "https://github.com/Keats/gutenberg.git"

  bottle do
    sha256 "3c13efb0ed3263a70a81036d55575be92e18c4f4b1e0652b906fa32ccfef48e7" => :mojave
    sha256 "3cb0122fc3082758478d8fea2c9933bc20882b7e33ea67b0e62019d7eb447c76" => :high_sierra
    sha256 "f0a8fa2af6664964168e8a2325cfb69c01af5009d2f1d1c65fd857772969d738" => :sierra
    sha256 "5489f83ea724f922d7ebda5bf6c7664c0fe46ef0e3e5e59b854826b2870839d7" => :el_capitan
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
