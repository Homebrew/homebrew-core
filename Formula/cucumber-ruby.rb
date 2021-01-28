class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/v5.3.0.tar.gz"
  sha256 "f8451032eea52c7ac6ff4b1ec0edb12f68c060d6a1b674e1c2dadc53b3c5f45f"
  license "MIT"

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
