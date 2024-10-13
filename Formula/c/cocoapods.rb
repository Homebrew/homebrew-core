class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/refs/tags/1.15.2.tar.gz"
  sha256 "324a13efb2c3461f489c275462528e9e721f83108d09d768d2049710d82d933c"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "616da75efe9421f6fdc9e3b6381f84626e8763073aff72094f30add258631dc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "441ca48d1042282ed261390fab8dfce1a56335340a98ae579b080b3f8c4e941a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "441ca48d1042282ed261390fab8dfce1a56335340a98ae579b080b3f8c4e941a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "441ca48d1042282ed261390fab8dfce1a56335340a98ae579b080b3f8c4e941a"
    sha256 cellar: :any_skip_relocation, sonoma:         "8961b95489c08fc5b163b09455e6172f5fdee7dcfacdad1c2bf569c28a476d8e"
    sha256 cellar: :any_skip_relocation, ventura:        "8961b95489c08fc5b163b09455e6172f5fdee7dcfacdad1c2bf569c28a476d8e"
    sha256 cellar: :any_skip_relocation, monterey:       "8961b95489c08fc5b163b09455e6172f5fdee7dcfacdad1c2bf569c28a476d8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf569151db36690ef517de97d64643d8a3425d88a214709fdc422d0494e5a5ad"
  end

  depends_on "pkg-config" => :build
  depends_on "ruby"
  uses_from_macos "libffi", since: :catalina

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
