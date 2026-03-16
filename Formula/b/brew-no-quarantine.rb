class BrewNoQuarantine < Formula
  desc "Homebrew wrapper to remove the quarantine attribute from casks"
  homepage "https://github.com/huangyxi/brew-no-quarantine"
  url "https://github.com/huangyxi/brew-no-quarantine/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "5284b86112bfcf5f380b3d7e8b06c0bd41ecb6f033e68a6816dd82154aa3daac"
  license "MIT"

  depends_on "ruby" => :build
  depends_on :macos

  def install
    ENV["BUNDLE_FORCE_RUBY_PLATFORM"] = "1"
    ENV["BUNDLE_WITHOUT"] = "development test"
    ENV["BUNDLE_VERSION"] = "system"
    ENV["GEM_HOME"] = libexec
    ENV["VERSION"] = version

    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"

    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    refute_empty shell_output("#{bin/name} --version")
  end
end
