class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/v3.1.2.tar.gz"
  sha256 "b0193098fdedd9ffbf8dc35dfc53113fb55a4f8a991b93ee0b44c1bfc9fcff45"

  bottle do
    cellar :any_skip_relocation
    sha256 "4dae16a128b3647f45cae985f994092c7455a3ea0de285a2a8a5f6bb2558f614" => :catalina
    sha256 "2ba7581d65bb36c8417f25a9275db93b52f03f57552f6cb7abd11b7cde88bb1d" => :mojave
    sha256 "290a326dfcdae9a4cb61765761814ba070729a8d0076e4110e6bc536905b6976" => :high_sierra
  end

  uses_from_macos "ruby"

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
