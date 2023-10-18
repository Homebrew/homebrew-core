class Pandocomatic < Formula
  desc "Automate the use of pandoc"
  homepage "https://heerdebeer.org/Software/markdown/pandocomatic/"
  url "https://github.com/htdebeer/pandocomatic/archive/1.1.1.tar.gz"
  sha256 "fb3b77f01cb52927163965fd911f9b59a04f133896b3a15d9aa1b56704a0d6e8"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4fce20eede304438d055535ccbbbaf811df1b1f3c294aa5844c7dfde5cdf0d38"
  end

  depends_on "pandoc"
  depends_on "ruby"

  resource "optimist" do
    url "https://rubygems.org/gems/optimist-3.0.1.gem"
    sha256 "336b753676d6117cad9301fac7e91dab4228f747d4e7179891ad3a163c64e2ed"
  end

  resource "paru" do
    url "https://rubygems.org/gems/paru-1.1.0.gem"
    sha256 "0c7406a398d9b356043a4a1bfee81f33947d056bb114e9dfb6a5e2c68806fe57"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end
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
