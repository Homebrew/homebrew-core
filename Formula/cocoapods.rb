class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.12.0.tar.gz"
  sha256 "ebd98e8c359f29b48059c077416d8c5d0c51817741aaa45efcf5356c89f3f1ae"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2f37d0c5e575d637c7d6a578c1c69eb170bfe69c6e1e5a38c236747084e90f49"
    sha256 cellar: :any,                 arm64_monterey: "f60a988dc4ea04e120075e8f40a1d59e729b331196a25c324d66b41a3f0a4fe1"
    sha256 cellar: :any,                 arm64_big_sur:  "b0e3ecfc1432ab8e0b3b919987319ae50af67b1678004d0f6e2a2de20a1e5de5"
    sha256 cellar: :any,                 ventura:        "1122628805532fd74c4b829f81a9ba26008f17e4e9bf4421457b748c5ab951d1"
    sha256 cellar: :any,                 monterey:       "46bd9890f4f414b925c8dab079724a7a75f46f023d850c7e5089defba531939c"
    sha256 cellar: :any,                 big_sur:        "7e7ee6e9cb8590eb00ff33a6024a6f4ed47efef4ae6bf916324729664f99d5d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8504ba65b8f1eb15f1dfe179c11cd7ba2216f3f54d6c20865442236c0b57c8ef"
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
