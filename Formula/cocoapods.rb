class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.12.0.tar.gz"
  sha256 "ebd98e8c359f29b48059c077416d8c5d0c51817741aaa45efcf5356c89f3f1ae"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "0a0e088cab176b333acec5d7b63e942fa95b84189ca503d4719ceaad77ab7d02"
    sha256 cellar: :any,                 arm64_monterey: "9717ff53b4af5304811ad8a5a80586cf13f8e02155813f526f26b0093e53261c"
    sha256 cellar: :any,                 arm64_big_sur:  "71c8e287680a1fe6d4430eb4600237e6c477eee79ad874e4f4976f82a99b0cdf"
    sha256                               ventura:        "8936f18dc0d3006eedd0197ea10aea25d2a26022b153ad18715bef62bab3dc3c"
    sha256                               monterey:       "2a61da56e48bfb8effb0c890fc8e131dfd98c2d14d51bf8fd1ed34ab95cf39e5"
    sha256                               big_sur:        "b0f7e8f4a57003c052ea3d8dc2ea69fffb838f8c80531889baf04d49113d5744"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dacd0df74ceb00ce3da1f73b53225813e49c25a64c2a0045e6610f078fb67fc4"
  end

  depends_on "pkg-config" => :build
  depends_on "ruby"
  uses_from_macos "libffi", since: :catalina

  def install
    if MacOS.version >= :mojave && MacOS::CLT.installed?
      ENV["SDKROOT"] = ENV["HOMEBREW_SDKROOT"] = MacOS::CLT.sdk_path(MacOS.version)
    end

    ENV["GEM_HOME"] = libexec
    system "gem", "build", "cocoapods.gemspec"
    system "gem", "install", "cocoapods-#{version}.gem"
    # Other executables don't work currently.
    bin.install libexec/"bin/pod", libexec/"bin/xcodeproj"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    system "#{bin}/pod", "list"
  end
end
