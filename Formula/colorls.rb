class Colorls < Formula
  desc "Ruby gem that beautifies the terminal's ls command, with color and icons"
  homepage "https://github.com/athityakumar/colorls"
  url "https://github.com/athityakumar/colorls/archive/v1.4.3.tar.gz"
  sha256 "2f224f96dff956278176ae76d49a16e50ab90d356ff0e50bb8f087bdf2d66dda"
  license "MIT"

  uses_from_macos "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])

    zsh_completion.install "zsh/_colorls"
  end

  test do
    system "colorls"
  end
end
