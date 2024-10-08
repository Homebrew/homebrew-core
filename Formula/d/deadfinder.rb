class Deadfinder < Formula
  desc "Finds broken links"
  homepage "https://rubygems.org/gems/deadfinder"
  url "https://github.com/hahwul/deadfinder/archive/refs/tags/1.4.2.tar.gz"
  sha256 "4986349e100bc3dd06c9063a61b072e266549a7c5d67e0b787646e529b54e4b7"
  license "MIT"
  head "https://github.com/hahwul/deadfinder.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "483894cf4b3e99decc906ca0e96a2ce042e6f14367d4b0586330e12cc9982ffe"
    sha256 cellar: :any,                 arm64_sonoma:  "b0df3b04ac10560f8a2c3385b9f6da7f62be3d42b79b3b77116d8ea356dba9bb"
    sha256 cellar: :any,                 arm64_ventura: "7b87883997ac8098f578acc6952f90ee9822f8f9c96fd095b2215e8b73ce2811"
    sha256 cellar: :any,                 sonoma:        "bc10cd63a742be1a04baf2b573747b9220a349509c5d5f9016774acb0446a0ab"
    sha256 cellar: :any,                 ventura:       "0672a08e2d8f0323eebb69688f26f3fe2298d8e68e72b95edbfeec1602916b1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "564455831dd75636dba3b0c6cc1e30410399e958ec700fd3ff4ee12a824aa03f"
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
