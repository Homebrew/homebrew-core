class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/v8.0.0.tar.gz"
  sha256 "5e382fc00fd04842813f58c7c7a1b43c2ddf6a8e5c53ae9916daba95462cdb6a"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               monterey:     "5b05d36faf72b95190f77acae632bd3a8ac4ba947df23262ea4bc1c6b2402004"
    sha256                               big_sur:      "30ac06c2908e0ca4ce7ba75e92393259911e454206a81c52f360b9aeda9a7c62"
    sha256 cellar: :any,                 catalina:     "ee1eabb3641184384650cb0990a2d54c0b9f346cd941274a40d7c427e0c70f5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0196d1843ab7614a204f29f4d10588d3397a4d89c9bdc2e297720ef3b6ac9899"
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
