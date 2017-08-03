class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.3.0.tar.gz"
  sha256 "3911e36ca3b3cf443b984d0f802b76b21458db493e35f1427e032c83b8339635"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b9566ecb99a91fb105dd4bb0ce7059ff89eddabc495fb386d0d317f64308c4c" => :sierra
    sha256 "33faf556d7e8ef624f42acf31677deaa1708ffd787cb66b5d5e495b00b2b0f59" => :el_capitan
    sha256 "516a923705fd0f8688c3ca0737171555e2a8536e745a3ff6b437f18d070b90d5" => :yosemite
  end

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "cocoapods.gemspec"
    system "gem", "install", "cocoapods-#{version}.gem"
    # Other executables don't work currently.
    bin.install libexec/"bin/pod", libexec/"bin/xcodeproj"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
  end

  test do
    system "#{bin}/pod", "list"
  end
end
