class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/v5.2.0.tar.gz"
  sha256 "273c9d98c5de487d91a6f35f289dd305964611fd01d5080df346bd42f11fffba"
  license "MIT"
  revision 1

  bottle do
    sha256 "7f15e3bf5bdeac38070b802f85d4828324d50085b5345e0148992af24b876181" => :big_sur
    sha256 "2afca64d3f15f52839cdfcb903e07a0a781e3537316d46be2cece665cc07ee71" => :catalina
    sha256 "05eb994b0c94f00ffe3bea8f740593f5c85fcfe4017e517a8b299ef2d78c34ba" => :mojave
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
