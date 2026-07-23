class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/refs/tags/1.17.0.tar.gz"
  sha256 "1a3e63e815e61ad7661326d6e6ba2593328a596ceb94953d4388e3fe01e27f90"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "636940f284ddcbe62825f3452a581b3d3f66d1db75e495ffdc756ed21caa58f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "636940f284ddcbe62825f3452a581b3d3f66d1db75e495ffdc756ed21caa58f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "636940f284ddcbe62825f3452a581b3d3f66d1db75e495ffdc756ed21caa58f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "57824c73e16eeb4483e532fb0d5898e5182ef66c7c3e9b7290e7bf5fcd4af4a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fb1ed067c58472749a51f5bca84db230ddf2bdd9e3937a0a49f13d529710b4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52d6eedadab8ef056483f9ff51c7d5b7307fb8fed2c2dded79a42fe6d3b08897"
  end

  depends_on "pkgconf" => :build
  depends_on "ruby"
  uses_from_macos "libffi"

  conflicts_with cask: "cocoapods-app", because: "both install `pod` binaries"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "cocoapods.gemspec"
    system "gem", "install", "cocoapods-#{version}.gem"
    # Other executables don't work currently.
    bin.install libexec/"bin/pod", libexec/"bin/xcodeproj"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    system bin/"pod", "list"
  end
end
