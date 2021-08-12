class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/v7.0.0.tar.gz"
  sha256 "6c0102449bf7de6f1aeb4f124f3cf61fc5bf6c09a008b57a5b922c95a1517478"
  license "MIT"

  bottle do
    sha256                               big_sur:      "3691175133692a65b8fbe2e7bdc56b33fe58ec22cf9279bb8b58f3b3276f2880"
    sha256 cellar: :any,                 catalina:     "cb41c2d80b483fa389c4549a06c81c2c1a0bb5813f8c002f1e25927e104c4d25"
    sha256 cellar: :any,                 mojave:       "3df8bc436b1aef23e0bfa13224d9c736be4d15f496c8772d27f69ce046a27342"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "95af524bfc94bb0e0c270a7d041a325a6a16590edad547801bfac2a82bd4ea42"
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
