class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/v7.0.0.tar.gz"
  sha256 "6c0102449bf7de6f1aeb4f124f3cf61fc5bf6c09a008b57a5b922c95a1517478"
  license "MIT"

  bottle do
    sha256                               big_sur:      "d1053be0ce5fb238c45bd404d5662c518d007d9c46ce72c889d0962fe357d7d6"
    sha256 cellar: :any,                 catalina:     "730af3e598806b9f40503460b8ea418f27765398036cbcdbf978554c1e21e67e"
    sha256 cellar: :any,                 mojave:       "5f68b35ebba784234f0ebf9ad2a68794eeb678a47291d077aafabe2dfadf4d46"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "52967a0bd1fee1cf7a1addf7c851741a61d5cc478f48f7bf75ac8a0511d59997"
  end

  depends_on "pkg-config" => :build

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "ruby", since: :big_sur

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "cucumber.gemspec"
    system "gem", "install", "cucumber-#{version}.gem"
    bin.install libexec/"bin/cucumber"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "create   features", shell_output("#{bin}/cucumber --init")
    assert_predicate testpath/"features", :exist?
  end
end
