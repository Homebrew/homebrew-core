class Pandocomatic < Formula
  desc "Automate the use of pandoc"
  homepage "https://heerdebeer.org/Software/markdown/pandocomatic/"
  url "https://github.com/htdebeer/pandocomatic/archive/0.2.7.6.tar.gz"
  sha256 "80549bf18bf03dc648fc8ed24d46a32ef2e0bde304949ad05b0ba2e6ac30e1cf"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a7049bd282b595c4b5f8b8bf2ae1142d3f36081b316360f0e3235dc6e5500757"
    sha256 cellar: :any_skip_relocation, big_sur:       "a7049bd282b595c4b5f8b8bf2ae1142d3f36081b316360f0e3235dc6e5500757"
    sha256 cellar: :any_skip_relocation, catalina:      "a7049bd282b595c4b5f8b8bf2ae1142d3f36081b316360f0e3235dc6e5500757"
    sha256 cellar: :any_skip_relocation, mojave:        "1c51680618ae42fe46954499c83137ad5fa1ecee95030b66015aafb0ddd2f9e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c51680618ae42fe46954499c83137ad5fa1ecee95030b66015aafb0ddd2f9e6"
    sha256 cellar: :any_skip_relocation, all:           "edde182eb548bb6cf6fc909820e0c9f7377592ab70be9342cbcb13a75a8e421e"
  end

  depends_on "pandoc"
  uses_from_macos "ruby", since: :catalina

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
      <p>A package manager for humans. Cats should take a look at Tigerbrew.</p>
    EOS
    system "#{bin}/pandocomatic", "-i", "test.md", "-o", "test.html"
    assert_equal expected_html, (testpath/"test.html").read
  end
end
