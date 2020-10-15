class Pandocomatic < Formula
  desc "Automate the use of pandoc"
  homepage "https://heerdebeer.org/Software/markdown/pandocomatic/"
  url "https://github.com/htdebeer/pandocomatic/archive/0.2.6.tar.gz"
  sha256 "902d1c366e85c14b5a3bc0fd5247b22fde985858f8f985e368e3eb7c03324e23"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8844df8b3f91e671a6734004ecb712db288adcf8952d17aa444e7cba8a29115" => :catalina
    sha256 "c3e059e365bf28455fbb0db2010e09195ff01b78ca02248bb6282f7d03136be2" => :mojave
    sha256 "5824fc9e4accf029a29ddc6dc31f1027d9e63d2752c316bcf941eddf75884b64" => :high_sierra
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
