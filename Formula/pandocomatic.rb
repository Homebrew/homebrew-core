class Pandocomatic < Formula
  desc "Automate the use of pandoc"
  homepage "https://heerdebeer.org/Software/markdown/pandocomatic/"
  url "https://github.com/htdebeer/pandocomatic/archive/0.2.7.4.tar.gz"
  sha256 "556799701cd1801046c599912141c1a4f50152880f0099dee08d767f541c50bd"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "8cc6d2218d4aaef9eb614d66784464123f7b735118e583ac6ff824303f7b2c86" => :catalina
    sha256 "473c84bc5f3ebbbff68fae54153a3f463562fab8cd422ef60ec43632a3c6f364" => :mojave
    sha256 "8d1d02f49374611d7e02c0e1c0b510de780903eb672f44afcc6a1fcaf1c876d1" => :high_sierra
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
