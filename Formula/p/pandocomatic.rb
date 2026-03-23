class Pandocomatic < Formula
  desc "Automate the use of pandoc"
  homepage "https://heerdebeer.org/Software/markdown/pandocomatic/"
  url "https://github.com/htdebeer/pandocomatic/archive/refs/tags/2.2.0.tar.gz"
  sha256 "8138b403aaa1d23db11701bf2bbcbf14447d89b7b05030fc2faf91d6fe11163c"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "94dead39e2809e446ca5663efc490bde891f3d0e61169c092e7a9b71e1c6d04b"
    sha256 cellar: :any,                 arm64_sequoia: "9fc14ce01a2aa580eed1b5d3ee9e640012b7c21047ee351b67e5fb9b3487da9b"
    sha256 cellar: :any,                 arm64_sonoma:  "0ec017678ab1e2383ae6ae3ddaa9f6ce41b27a9cf524cb07e9626d6ad6a91bb3"
    sha256 cellar: :any,                 sonoma:        "108f671c2357bb6574f6f139b0e84ba591c938d58ea2dc5da311b7f5c578bf3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1260ba565529a1e73f1e4ab697c498b1a6e7338de14884483cc3cbeee61262b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "476704ca09fb05e3a0bc5b75818886130c40b05f72ca4b35dbd35a502997910c"
  end

  depends_on "libyaml"
  depends_on "pandoc"
  depends_on "ruby@3.4"

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
