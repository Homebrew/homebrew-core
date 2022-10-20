class Pandocomatic < Formula
  desc "Automate the use of pandoc"
  homepage "https://heerdebeer.org/Software/markdown/pandocomatic/"
  url "https://github.com/htdebeer/pandocomatic/archive/1.0.0.tar.gz"
  sha256 "22fc1802afc74ead9fc1011180c005c63932e8430aef61984dfaa43efb64c2d4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8b34b6ee72883fc87162ceab902d17da2f375ba06a1bdd75aa271bf46c17bba0"
  end

  depends_on "pandoc"
  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    (testpath/"test.md").write <<~EOS
      # Homebrew

      A package manager for humans. Cats should take a look at Tigerbrew.
    EOS
    expected_html = <<~EOS
      <h1 id="homebrew">Homebrew</h1>
      <p>A package manager for humans. Cats should take a look at
      Tigerbrew.</p>
    EOS
    system "#{bin}/pandocomatic", "-i", "test.md", "-o", "test.html"
    assert_equal expected_html, (testpath/"test.html").read
  end
end
