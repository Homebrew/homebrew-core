class Pandocomatic < Formula
  desc "Automate the use of pandoc"
  homepage "https://heerdebeer.org/Software/markdown/pandocomatic/"
  url "https://github.com/htdebeer/pandocomatic/archive/refs/tags/2.2.0.tar.gz"
  sha256 "8138b403aaa1d23db11701bf2bbcbf14447d89b7b05030fc2faf91d6fe11163c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "610b5a3d8aedb25990e082c6ba6630be1f9ee44a4ee0bbd20cc67927fb36ee9d"
    sha256 cellar: :any,                 arm64_sequoia: "67ddc692dda68137b2384cf9f9030026bab8e28807b332b147d345dde7f9d22b"
    sha256 cellar: :any,                 arm64_sonoma:  "cd06357a968155b8bfc0668778ee80cb42e0f39364d4e448aa5a2bbe26c9f71a"
    sha256 cellar: :any,                 sonoma:        "ba9c0a766d2d9867c0db458eb4f0241fdc0dc556b2c7474e6a2ba7f6936300a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55b246ba8c864a25928422f8fca0498ff2814fd680fa68e266c7882f43998b4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac22e7a5377dd38a6dfc21dd73c3615ac2d0cae4c6c6f441ce9d74aa93334c8a"
  end

  depends_on "libyaml"
  depends_on "pandoc"
  depends_on "ruby"

  def install
    ENV["BUNDLE_FORCE_RUBY_PLATFORM"] = "1"
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["BUNDLE_WITHOUT"] = "development test"
    ENV["GEM_HOME"] = libexec

    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"

    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])

    # Remove mkmf.log files to avoid shims references
    rm Dir["#{libexec}/extensions/*/*/*/mkmf.log"]
  end

  test do
    (testpath/"test.md").write <<~MARKDOWN
      # Homebrew

      A package manager for humans. Cats should take a look at Tigerbrew.
    MARKDOWN
    expected_html = <<~HTML
      <h1 id="homebrew">Homebrew</h1>
      <p>A package manager for humans. Cats should take a look at
      Tigerbrew.</p>
    HTML
    system bin/"pandocomatic", "-i", "test.md", "-o", "test.html"
    assert_equal expected_html, (testpath/"test.html").read
  end
end
