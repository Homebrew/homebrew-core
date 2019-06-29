class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.7.3.tar.gz"
  sha256 "770b97958f556cdf22a3203b8755a1650e40b9934c47184a08e1735553da6119"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c454d3e7ae59e00988741ca308e072a689e7192116447ecace1ee3512fe2fab" => :mojave
    sha256 "550e75e6075d8d668424f9dfb68859f713548b7b807814b8083ce6cc6b396de1" => :high_sierra
    sha256 "e1769e0050aef6cc183547ff14406034536dd2885f64571dcfcc555926e83cd3" => :sierra
  end

  depends_on "ruby" if MacOS.version <= :sierra

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
