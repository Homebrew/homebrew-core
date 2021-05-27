class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/v6.1.0.tar.gz"
  sha256 "dfa4e1ef20498255f1c1dcd089add0e2e427f11d6bb53c06184ed4f70385ce1b"
  license "MIT"

  bottle do
    sha256               big_sur:  "3242cbdc2387d58308c92b4ff9cfdae04e9be67ce7e50681b862a03cd0a6e964"
    sha256 cellar: :any, catalina: "f9ac5ad41fb8363c4577609cd347b08a00f28a61a4df1485d4b31d54e7b54b6c"
    sha256 cellar: :any, mojave:   "27fec91ee466eca329af0c3ac503a6b5d20c558fb38b034509ee09efc56534c9"
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
