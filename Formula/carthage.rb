class Carthage < Formula
  desc "Decentralized dependency manager for Cocoa"
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git", :tag => "0.16",
                                                  :revision => "39be4da2159e11dd5375385075139c7107835047",
                                                  :shallow => false
  head "https://github.com/Carthage/Carthage.git", :shallow => false

  bottle do
    cellar :any
    sha256 "a874de769bddd24ee525e2a2d0a3ad30f8a03bc9725e80a89000a7c90ac41f5f" => :el_capitan
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
