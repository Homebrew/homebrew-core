class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/v5.1.1.tar.gz"
  sha256 "a2dded4fe9e629a2925e74f00e1c7c24dd2f08ea17f4474c2332052d73788acd"
  license "MIT"

  bottle do
    sha256 "2818db64905d2e7c936bee32fa6e5098705d4b9986cd3f1abe5df72e67c50193" => :catalina
    sha256 "7229b37fdca6d806523bf60e3ac712e56fe4306917fcafa017ec951fa7d194e9" => :mojave
    sha256 "ee7ec4ee8bb671091422ab866e2d9696762d60a03681e1080138928a536b17e5" => :high_sierra
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
