class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.9.3.tar.gz"
  sha256 "12d8f52dcfbaf0f4b3e52001e072e26aa3c967e1c41e84511e84b587ae434e27"
  license "MIT"

  bottle do
    sha256 "70f8c793bb60631422db028bbebb64ba9fcc1085a216abe5e625357380e06d46" => :catalina
    sha256 "074e5b53b7a054c132582183dcf47546ddd028a7beb9fcdc653fe4a43225bcf3" => :mojave
    sha256 "61d9473fd19573cebe3401921c69b8bc69eba9c096de654776a24dedd089ce65" => :high_sierra
  end

  depends_on "pkg-config" => :build

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "ruby", since: :catalina

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
