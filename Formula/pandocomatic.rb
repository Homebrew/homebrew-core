class Pandocomatic < Formula
  desc "Automate the use of pandoc"
  homepage "https://heerdebeer.org/Software/markdown/pandocomatic/"
  url "https://github.com/htdebeer/pandocomatic/archive/0.2.7.5.tar.gz"
  sha256 "42de0b48fb751b5142f4f0fd695f709ce78b62635b9e076e21bc2e3d4a3287a0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a10d18e6e50807a796a89566d5a5cc16ecf976af445b895d242b5278c6d228ad"
    sha256 cellar: :any_skip_relocation, big_sur:       "1236328c4bec43942120f816ba96fba584e5324df24b14d2f94aad6ad6a4ddcc"
    sha256 cellar: :any_skip_relocation, catalina:      "fc8ec0244c32608753851a3cded8a10fb569ab39794a96f7a5a665b1bacc7fa9"
    sha256 cellar: :any_skip_relocation, mojave:        "b5ec22ce7c10ce2f01a9a044eb200b61e00d7c551ca3847b738ad2e632978d83"
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
