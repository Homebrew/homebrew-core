class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.6.1.tar.gz"
  sha256 "482fbb5c89d1c7c4456f9c1aba3b6ee41cfe74f8ea389a4d3a0b0415d30cda40"

  bottle do
    cellar :any_skip_relocation
    sha256 "17db9489e0ca4fb2349b1f0046d7b5224a5764c420f575947719f605c3828d97" => :mojave
    sha256 "fc004c866c668214225c4cc606bc00dc1418c577be1d58f166075ba998d32f6a" => :high_sierra
    sha256 "9c31c82dd47fe218430bb21ff6b699e928d6f5df46ac0b7483ec679d678916a5" => :sierra
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
