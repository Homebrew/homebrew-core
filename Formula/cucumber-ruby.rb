class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/v5.2.0.tar.gz"
  sha256 "273c9d98c5de487d91a6f35f289dd305964611fd01d5080df346bd42f11fffba"
  license "MIT"

  bottle do
    sha256 "c4fb3a8d15b987dbdb1e8c7d10e1b646c3cdf2af77d71f7ebeb103a30d15f732" => :catalina
    sha256 "09a27799d3ba6896e10d84d0c040cfecc8d63da04c98729987490db29941a373" => :mojave
    sha256 "effc117d5594efbb573261c412c13cc4ba3c17a422d901c083ec020a3624c0e8" => :high_sierra
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
