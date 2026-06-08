class Opal < Formula
  desc "Ruby to JavaScript transpiler"
  homepage "https://opalrb.com/"
  url "https://github.com/opal/opal.git",
      tag:      "v1.8.3",
      revision: "54a8bbbf582458b66ab3b52e68bbf2b73281751a"
  license "MIT"
  head "https://github.com/opal/opal.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "40b8c2cfd5220e86a52258ba5bead37074662a0858fe98befcf418493216a525"
    sha256 cellar: :any, arm64_sequoia: "6d4ad65707a9a88d762b97d2cdf1da579993e75eb9cfd6e45776ff47042ad695"
    sha256 cellar: :any, arm64_sonoma:  "8a882605b9340565a631f3f18a9ceea850881ac2a114f3ea97c2a3b3f1ca9d56"
    sha256 cellar: :any, sonoma:        "d6a1fdb07b465f696848972ddbc9b33e1b902d8a0029730bd70610011381341c"
    sha256 cellar: :any, arm64_linux:   "dbd7bac3537bbf25849dcb9136d8b94982a94521a6a1a584a152e15a0aeed012"
    sha256 cellar: :any, x86_64_linux:  "0420aaf659871f8472cd3c44cbde5d7a449c247cda5a2b33064b684c46960ed2"
  end

  depends_on "quickjs" => :test
  depends_on "ruby"

  # List with `gem install --explain opal --platform ruby -v #{version}`
  resource "racc" do
    url "https://rubygems.org/gems/racc-1.8.1.gem"
    sha256 "4a7f6929691dbec8b5209a0b373bc2614882b55fc5d2e447a21aaa691303d62f"
  end

  resource "ast" do
    url "https://rubygems.org/gems/ast-2.4.3.gem"
    sha256 "954615157c1d6a382bc27d690d973195e79db7f55e9765ac7c481c60bdb4d383"
  end

  resource "parser" do
    url "https://rubygems.org/gems/parser-3.3.11.1.gem"
    sha256 "d17ace7aabe3e72c3cc94043714be27cc6f852f104d81aa284c2281aecc65d54"
  end

  resource "base64" do
    url "https://rubygems.org/gems/base64-0.3.0.gem"
    sha256 "27337aeabad6ffae05c265c450490628ef3ebd4b67be58257393227588f5a97b"
  end

  def install
    ENV["GEM_HOME"] = libexec

    resources.each do |r|
      system "gem", "install", r.cached_download, "--ignore-dependencies", "--no-document", "--install-dir", libexec
    end
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "--ignore-dependencies", "#{name}-#{version}.gem"
    %w[opal opal-build opal-repl].each do |program|
      bin.install libexec/"bin/#{program}"
    end
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    (testpath/"test.rb").write "puts 'Hello world!'"
    assert_equal "Hello world!", shell_output("#{bin}/opal --runner quickjs test.rb").strip

    system bin/"opal", "--compile", "test.rb", "--output", "test.js"
    assert_equal "Hello world!", shell_output("#{Formula["quickjs"].opt_bin}/qjs test.js").strip
  end
end
