class Deadfinder < Formula
  desc "Finds broken links"
  homepage "https://rubygems.org/gems/deadfinder"
  url "https://github.com/hahwul/deadfinder/archive/refs/tags/1.4.4.tar.gz"
  sha256 "65be55ddea901827b033b5b9c94edb8ceba5c83f70af38e99f340d4239c902d6"
  license "MIT"
  head "https://github.com/hahwul/deadfinder.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "85435034ec7c61873c5ce16758d97d5f006d14d7293b6b1d675c3c0b7097b59e"
    sha256 cellar: :any,                 arm64_sonoma:  "e5f626e7d3b0dd45139a4ee5bb5b28373c1afb970a6cd6a9f911559ee5b52eab"
    sha256 cellar: :any,                 arm64_ventura: "a5e6d89f92472c86095c31e191d6015c59e8a7bda91a1d50ca1747c6d0236042"
    sha256 cellar: :any,                 sonoma:        "2debc32e465180735991d140398a510c1dec980533bcfa6e3858f32325487ba0"
    sha256 cellar: :any,                 ventura:       "547df6f7924cfb7b4071fd481993460b26890eacc9e9e37b7aa84b86ed7944c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "532eb37efcd65401cdc221972b3e25cf648aae3c0b3b1c9cff6a231b1fe1329e"
  end

  depends_on "ruby"

  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
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
  end

  test do
    assert_match version.to_s, shell_output(bin/"deadfinder version")

    assert_match "Done", shell_output(bin/"deadfinder url https://brew.sh")
  end
end
