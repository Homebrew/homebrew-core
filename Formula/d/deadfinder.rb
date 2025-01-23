class Deadfinder < Formula
  desc "Finds broken links"
  homepage "https://rubygems.org/gems/deadfinder"
  url "https://github.com/hahwul/deadfinder/archive/refs/tags/1.5.1.tar.gz"
  sha256 "76231a6be701233e8d5d40801f290de518676600674f5d8e9edbd4a0a5e06434"
  license "MIT"
  head "https://github.com/hahwul/deadfinder.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "99d819092b4f6c146c27b6cd6ac19bba0ccca95a96897fa066b705b647c433a6"
    sha256 cellar: :any,                 arm64_sonoma:  "d599cb7a90edcac878a70b246db1b1843aa18977974368814601d6cbe8ad219f"
    sha256 cellar: :any,                 arm64_ventura: "1fcaec32a0142242f04e59cf3559e35b57b0e23cbb515e1ac2290c23d86fcce9"
    sha256 cellar: :any,                 sonoma:        "389e2895b0743d63ebd171da7513354d3b4562abb524622dd9dcb8f8647b2f72"
    sha256 cellar: :any,                 ventura:       "6ecd716260855740c609f74f0d0e0ecc8f2eacb5b92a3c7a31c62d0c105c4925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0047973ae4b0f35258292de78fc3f5f3f6470c4cae62e74f3e995ed93b62af4a"
  end

  depends_on "ruby"

  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["NOKOGIRI_USE_SYSTEM_LIBRARIES"] = "1"

    system "bundle", "config", "set", "without", "development", "test"
    system "bundle", "install"
    system "gem", "build", "deadfinder.gemspec"
    system "gem", "install", "deadfinder-#{version}.gem"

    bin.install libexec/"bin/deadfinder"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])

    # Remove mkmf.log files to avoid shims references
    rm Dir["#{libexec}/extensions/*/*/*/mkmf.log"]
  end

  test do
    assert_match version.to_s, shell_output(bin/"deadfinder version")

    assert_match "Done", shell_output(bin/"deadfinder url https://brew.sh")
  end
end
