class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/v4.1.0.tar.gz"
  sha256 "56c52316fc91b8a9f284adb86e145b9314d5c417e73f0f8e32b91228f3f8c1f6"
  license "MIT"

  bottle do
    sha256 "2cb28eaaceddd08eb37eb3435c17d84c162cc2ffe92d4df5dd07674a94e65101" => :catalina
    sha256 "fb8d3ca0b4824a2e11c8002ba64923a11895e0ac0e01bf77f70fc57a4ac7fc00" => :mojave
    sha256 "f99d2fe27c870177a55e1ab115c83b89192d9e2cd230adced2516d2e8f4180c1" => :high_sierra
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
