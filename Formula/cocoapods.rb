class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.4.0.tar.gz"
  sha256 "c0044f1f74cfe88e6c671dc8225ea8fb94235c6155ca15f1676266f7ef5ba7c5"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d2df25c8e97fdbaece1f6f8c5c194cf0f1ba76f5f9b7dfdb15b376fac619e02" => :high_sierra
    sha256 "dfa91a4ddb802965ab2f7092771aa77e1e87de7f810626af5eb0e2f369d9dee9" => :sierra
    sha256 "b2a3a6356a49ab31e2ee8a5314a67f48cea79590fbfc806a597f31cc647461d0" => :el_capitan
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
