class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/v4.1.0.tar.gz"
  sha256 "56c52316fc91b8a9f284adb86e145b9314d5c417e73f0f8e32b91228f3f8c1f6"

  bottle do
    sha256 "2d892e849fd1ab7316828b4abfe97a44c57183ccebd229ab36e5524a88f9cccd" => :catalina
    sha256 "5c4665caf4f97a942ee7f6d104c34cfde3bf2a0d303d724283bc7cbaa05b3fa9" => :mojave
    sha256 "fe710e1054db86c901f9eb84d164fdf92faf474b3f1f83b72689b8054e350f22" => :high_sierra
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
