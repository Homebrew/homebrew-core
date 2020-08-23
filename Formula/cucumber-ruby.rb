class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/v5.0.0.tar.gz"
  sha256 "f9f7c5c38ee4d5df8422d44e68af7474f46704be010b007652d8b346e0eec09c"
  license "MIT"

  bottle do
    sha256 "f169c7e71b77d2b1630bd317afbe996f9ed98fdf70848dcc4409be237901f0f8" => :catalina
    sha256 "c78dc3c027e05f635fc6e58d3bb264433e5a2ea5ef3db65c8dd9d285d9b6b24c" => :mojave
    sha256 "93072b281b33bbb2bba805ea521057049752de801b74588bb437ab90f8e6d6f7" => :high_sierra
  end

  depends_on "pkg-config" => :build

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "ruby", since: :catalina

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
