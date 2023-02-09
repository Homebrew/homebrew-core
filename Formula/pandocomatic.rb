class Pandocomatic < Formula
  desc "Automate the use of pandoc"
  homepage "https://heerdebeer.org/Software/markdown/pandocomatic/"
  url "https://github.com/htdebeer/pandocomatic/archive/1.1.0.tar.gz"
  sha256 "33a2f2ac628c54851be1b5b10114b3e086f08efd8c28826d00608fca1f3616b7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8b34b6ee72883fc87162ceab902d17da2f375ba06a1bdd75aa271bf46c17bba0"
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
