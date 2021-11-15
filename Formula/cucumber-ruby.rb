class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/v7.1.0.tar.gz"
  sha256 "8eafa529f1c8793de09b550b68067af1f3d1b05e8eca798f5755d05ee0aacf8c"
  license "MIT"

  bottle do
    sha256                               monterey:     "d6ff6562f6a7d518d4ed7ad5986a2f58f7331bfa87d67f03b35603e4cdcdf15d"
    sha256                               big_sur:      "a92759a27d110dd3884a8d421d7c507e3f0424afc5cc3994912ec57dfce1a47a"
    sha256 cellar: :any,                 catalina:     "91f7a0452a265adc52220a926b74daf33d346a6659d71448110acbbb56781854"
    sha256 cellar: :any,                 mojave:       "0fc96a4a30d70ddd88e725f6f3ffd4ecfc4f5f0d640546fea803d8407f392752"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e9e9cea603b814907f60395901d4d9ca039a897930dde2a718516e8a4385aa4f"
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
