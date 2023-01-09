class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.11.3.tar.gz"
  sha256 "91d31754611520529b101ee57a059c5caadcd7ddb3c5b3b1065edc0ef5c43372"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6a01a07ff0f9e850580a6a8983fccf0937e16afd9a593b1f81df3ea3e767c558"
    sha256 cellar: :any,                 arm64_monterey: "3fb1d8c4f5c90970b02d9e52d1bf478b07821afcd6b0f9e4a681fb3f294c0806"
    sha256 cellar: :any,                 arm64_big_sur:  "bfbcbe149a4018d90fa8b3648ca6f0d3e89b65c7e87077287d268c5bf1f9c7db"
    sha256                               ventura:        "4728d00fd0a195714d6d121828bd5673b4a48a74ba74782a5a3e5167f7283241"
    sha256                               monterey:       "21d0a818bc54618cbce712babf75810587238044cedcb5eae67dfddc745405c1"
    sha256                               big_sur:        "6ec901eefb69c8b34fdd210c6e64e694acb08c30c4f92087ace14f01197ea8de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb0fed2b50fcef4cc0c822e135bf8ea0cfc73143d8b4f361a7b96aecd4294c41"
  end

  depends_on "pkg-config" => :build
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "ruby", since: :catalina

  on_arm do
    depends_on "ruby"
  end

  # Fix compatibility with Ruby 3.2, remove in next release
  patch do
    url "https://github.com/CocoaPods/CocoaPods/commit/2af8ba7e3477296d975243eeb1c12f379ab556a1.patch?full_index=1"
    sha256 "391da12230d5e413853d96af7f310f5e588e80974df82caf1284c3d6f467cabc"
  end

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
