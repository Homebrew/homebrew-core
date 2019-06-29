class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.7.3.tar.gz"
  sha256 "770b97958f556cdf22a3203b8755a1650e40b9934c47184a08e1735553da6119"

  bottle do
    cellar :any_skip_relocation
    sha256 "c5b675f7f61d73c70d2b447706d15baf0a341f4202af399b364bf82e80259866" => :mojave
    sha256 "47eab9213950fb01582ec99ad864ab348757b470f2e37e7f26e5431dda5b489c" => :high_sierra
    sha256 "61a6d42c9881f49835dd22a595307d93598e55f36fd5b9b67239c653f153d198" => :sierra
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
