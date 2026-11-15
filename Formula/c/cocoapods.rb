class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/refs/tags/1.17.0.tar.gz"
  sha256 "1a3e63e815e61ad7661326d6e6ba2593328a596ceb94953d4388e3fe01e27f90"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "518d2ab4921ca19bd794420c1f8994697851facb47c26087f36f80f64810e1ed"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "518d2ab4921ca19bd794420c1f8994697851facb47c26087f36f80f64810e1ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "518d2ab4921ca19bd794420c1f8994697851facb47c26087f36f80f64810e1ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "87dca6923355e6b2c4f98a731c003cb9420ec05d16667bea1d725a351ba359cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2e0a3e351b9d567c6646cbc8ae491e34af42b7c434cbca33a2a02ad79eb63d39"
  end

  depends_on "pkgconf" => :build
  depends_on "ruby"
  uses_from_macos "libffi"

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
