class Pandocomatic < Formula
  desc "Automate the use of pandoc"
  homepage "https://heerdebeer.org/Software/markdown/pandocomatic/"
  url "https://github.com/htdebeer/pandocomatic/archive/1.1.0.tar.gz"
  sha256 "33a2f2ac628c54851be1b5b10114b3e086f08efd8c28826d00608fca1f3616b7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9abbea036a1372d49f6e9899245c1db85511bc6f28d9fd62a642b5128667144f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "616b071224287c3bd23821bb94370d70bedbf9f0a8514c76f1e544ccca154d13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "398647fcd48426030abd0d18982d88efe8172a0c05d0f90411cab296bcbf82f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e6ed041218382e0d6d8053cc11686b1d5c4ff6fe194ec9ac972d589dd401458"
    sha256 cellar: :any_skip_relocation, sonoma:         "9abbea036a1372d49f6e9899245c1db85511bc6f28d9fd62a642b5128667144f"
    sha256 cellar: :any_skip_relocation, ventura:        "a1af4d7f532aa67cdfb71774a191289bafbe0b106e9d4082759d260c26707538"
    sha256 cellar: :any_skip_relocation, monterey:       "a8cf033cebd1ab5496fb4b98a89ef449350b566865acdded8036b1396663e10e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4a88264a1b130ae26c88bd53db3e7f3e2607a64fcc05e0934c25203a05216a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2d5914d3a0774bfab870ee4a6d38efbadafd7312f70bc4815a6bb67c43ad907"
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
