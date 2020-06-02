class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/v4.0.0.tar.gz"
  sha256 "de1eb7b99d0e03e851e8d7d1aacb9939590dc7f5d2d2d91180917e6f20c22ebe"

  bottle do
    sha256 "1bbd39ef420f725cd23b38f43993a1fd34b1c8d72b20895b57d5a3f7505435dc" => :catalina
    sha256 "9cfc5742cad48dc3c4d469600dc42b90778c82e89f41a2aecc8b6a4d7832ad6e" => :mojave
    sha256 "5a675b87cce18a91a495077d37c7d57afc645e6b973fb09720d18756fef223b3" => :high_sierra
  end

  depends_on "pkg-config" => :build

  uses_from_macos "libffi", :since => :catalina
  uses_from_macos "ruby", :since => :catalina

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "cucumber.gemspec"
    system "gem", "install", "cucumber-#{version}.gem"
    bin.install libexec/"bin/cucumber"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
  end

  test do
    assert_match "create   features", shell_output("#{bin}/cucumber --init")
    assert_predicate testpath/"features", :exist?
  end
end
