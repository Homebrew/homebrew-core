class Pandocomatic < Formula
  desc "Automate the use of pandoc"
  homepage "https://heerdebeer.org/Software/markdown/pandocomatic/"
  url "https://github.com/htdebeer/pandocomatic/archive/refs/tags/2.0.0.tar.gz"
  sha256 "57953b994e4c2f5a9736d772c4f0c18850cfdba0913dbf849c131d76cf26fc04"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b0cb8847ca852e95ec9fae012a947bc49cd853c7cfe74c9082d9d0753451477a"
  end

  depends_on "pandoc"
  depends_on "ruby"

  resource "csv" do
    url "https://rubygems.org/gems/csv-3.3.0.gem"
    sha256 "0bbd1defdc31134abefed027a639b3723c2753862150f4c3ee61cab71b20d67d"
  end

  resource "optimist" do
    url "https://rubygems.org/gems/optimist-3.1.0.gem"
    sha256 "81886f53ee8919f330aa30076d320d88eef9bc85aae2275376b4afb007c69260"
  end

  resource "paru" do
    url "https://rubygems.org/gems/paru-1.4.1.gem"
    sha256 "43489a7d3b7ff4dba8032c66d94ea65aaf49e2fd504740fbdc446caa76c860eb"
  end

  resource "logger" do
    url "https://rubygems.org/gems/logger-1.6.0.gem"
    sha256 "0ab7c120262dd8de2a18cb8d377f1f318cbe98535160a508af9e7710ff43ef3e"
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
    system bin/"pandocomatic", "-i", "test.md", "-o", "test.html"
    assert_equal expected_html, (testpath/"test.html").read
  end
end
