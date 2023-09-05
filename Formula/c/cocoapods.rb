class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.12.1.tar.gz"
  sha256 "da018fc61694753ecb7ac33b21215fd6fb2ba660bd7d6c56245891de1a5f061c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6f1fca1cb0df79912e10743a80522e666fe605a1eaa2aac1094c501608fb7ee4"
    sha256 cellar: :any,                 arm64_monterey: "8f7eff899cc1807286374e29e634c1008e286c3360df6cbcb90e27b0fe5567a9"
    sha256 cellar: :any,                 arm64_big_sur:  "346833fef239df933ddb67341c55c9c4a7e547fc03afdc332861ac2ae8ba3372"
    sha256 cellar: :any,                 ventura:        "b114ec0a11a2e472026f0f7337d17558bead2ac1122d9c2bb9278fc6b31fd744"
    sha256 cellar: :any,                 monterey:       "946f0282afe0000ba9e23f30ce2175bc4b1f0c6d7e27145f01be4665b9786f8a"
    sha256 cellar: :any,                 big_sur:        "1fe6f0c45e0c13e122aa1d8bf1f9bd9496fa3bb00fe7bc19286425e029e5c278"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e297731632b715118c13688acff976ce56c49df705ba2ae616445fb68cb49152"
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
