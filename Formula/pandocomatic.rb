class Pandocomatic < Formula
  desc "Automate the use of pandoc"
  homepage "https://heerdebeer.org/Software/markdown/pandocomatic/"
  url "https://github.com/htdebeer/pandocomatic/archive/0.2.7.4.tar.gz"
  sha256 "556799701cd1801046c599912141c1a4f50152880f0099dee08d767f541c50bd"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "42c46256c89f62097987aace0b1666d21dd8eadbffb24cdfa21c6ba54cd576f9" => :big_sur
    sha256 "462b6fb04be99bd19985476d36d29b26625a8ada343ec41f8373c0f7fcf11033" => :catalina
    sha256 "f4a6df084b43ebe5a123dbeeef27881d737aec895df518050eb948a6d7712b1a" => :mojave
    sha256 "8f6ca37732470b38636fd37d6d5a7c75b15e6642fdd8a3fdbe2e57b196ca2fcf" => :high_sierra
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
