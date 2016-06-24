class Carthage < Formula
  desc "Decentralized dependency manager for Cocoa"
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git", :tag => "0.17.1",
                                                  :revision => "2c2fdde4fff3f915ba8f1c91af1fd97cedd0cea0",
                                                  :shallow => false
  head "https://github.com/Carthage/Carthage.git", :shallow => false

  bottle do
    cellar :any
    sha256 "2872de583b12dcc90253b56aebac8857ef902d32179a678c1ba371eb0e43abaa" => :el_capitan
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
