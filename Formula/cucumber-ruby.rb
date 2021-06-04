class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/v6.1.0.tar.gz"
  sha256 "dfa4e1ef20498255f1c1dcd089add0e2e427f11d6bb53c06184ed4f70385ce1b"
  license "MIT"

  bottle do
    sha256               big_sur:  "d1053be0ce5fb238c45bd404d5662c518d007d9c46ce72c889d0962fe357d7d6"
    sha256 cellar: :any, catalina: "730af3e598806b9f40503460b8ea418f27765398036cbcdbf978554c1e21e67e"
    sha256 cellar: :any, mojave:   "5f68b35ebba784234f0ebf9ad2a68794eeb678a47291d077aafabe2dfadf4d46"
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
