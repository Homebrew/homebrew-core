class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.13.0.tar.gz"
  sha256 "acc1c331d9120e6a4fe73094f0748d5744d2445f01e266ad3b567d6d777158a9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a3315bfd8fdd6273d30744ab2bb6fcc5a7316534f0969c7a8baf9dfb28c0c940"
    sha256 cellar: :any,                 arm64_ventura:  "b3fe75543e09903f2f31b7a70de1812ff89d71422207a0e1d75c66711e5ad898"
    sha256 cellar: :any,                 arm64_monterey: "66c7da5278b764cc39069da5744dfa3885f15a6e7f860bb629b21a6e26f49f17"
    sha256 cellar: :any,                 arm64_big_sur:  "f6961f01c0b4816ef520343b8a63a78230870c3b7e68ae639dddf4c23d02a9d9"
    sha256 cellar: :any,                 sonoma:         "99864a97a35c64e2edabce6def450eb82d120be291b4328d83cdf9e6e92db936"
    sha256 cellar: :any,                 ventura:        "25dfd3c10dd4b166b6efc929afb2e5a8e4213872456d4dc14f44b36adf241931"
    sha256 cellar: :any,                 monterey:       "2e8e355ea4f6febcf86aae62977cf95d6f5216136da2e6b6754500228a0adab8"
    sha256 cellar: :any,                 big_sur:        "16f058a34ac1b09c983aa192c785a53222e04cad4edb43b69230ab7354aa8749"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb75b7690ff99d4258ba7a5a4b0c61b49169925989a4b67f89e1a530eb275015"
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
