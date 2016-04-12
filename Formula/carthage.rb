class Carthage < Formula
  desc "Decentralized dependency manager for Cocoa"
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git", :tag => "0.16.1",
                                                  :revision => "382911a127d29d6119d8512834a0bb77c58f2ebc",
                                                  :shallow => false
  head "https://github.com/Carthage/Carthage.git", :shallow => false

  bottle do
    cellar :any
    sha256 "1b9685f6e0500b552bfac615dcb51a110fa208ba0a203b8527a151f84b11a15f" => :el_capitan
  end

  depends_on :xcode => ["7.3", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"Cartfile").write 'github "jspahrsummers/xcconfigs"'
    system "#{bin}/carthage", "update"
  end
end
