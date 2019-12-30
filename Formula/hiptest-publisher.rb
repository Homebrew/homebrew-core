class HiptestPublisher < Formula
  desc "Publisher for HipTest projects"
  homepage "https://github.com/hiptest/hiptest-publisher"
  url "https://github.com/hiptest/hiptest-publisher/archive/v2.0.0.tar.gz"
  sha256 "ec2e89637655935616e7f427778c4dbe205891ea0f58e9b30c7130532a48dcfe"
  head "https://github.com/hiptest/hiptest-publisher.git"

  uses_from_macos "ruby"

  def install
    libexec.install "Gemfile", "Gemfile.lock"
    ENV["GEM_HOME"] = libexec
    ENV["BUNDLE_PATH"] = libexec
    ENV["BUNDLE_GEMFILE"] = libexec/"Gemfile"
    system "gem", "install", "bundler"
    bundle = Dir["#{libexec}/**/bundle"].last
    system bundle, "install"

    system "gem", "build", "hiptest-publisher.gemspec"
    system "gem", "install", "--ignore-dependencies", "hiptest-publisher-#{version}.gem"
    bin.install libexec/"bin/hiptest-publisher"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
  end

  test do
    output = shell_output("#{bin}/hiptest-publisher --token=12345")
    assert_match "No project found with this secret token", output
  end
end
