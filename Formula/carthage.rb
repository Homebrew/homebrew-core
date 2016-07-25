class Carthage < Formula
  desc "Decentralized dependency manager for Cocoa"
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git", :tag => "0.17.2",
                                                  :revision => "6b9728006ef8a7ceaeda5687c052e05dc8e49d02",
                                                  :shallow => false
  head "https://github.com/Carthage/Carthage.git", :shallow => false

  bottle do
    cellar :any
    sha256 "2257a3be7fbce5340329fead069903d16ff1ddd342b233aee724096148af2bac" => :el_capitan
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
