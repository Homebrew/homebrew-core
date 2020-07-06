class Iblinter < Formula
  desc "Linter tool for Interface Builder"
  homepage "https://github.com/IBDecodable/IBLinter"
  url "https://github.com/IBDecodable/IBLinter/archive/0.4.23.tar.gz"
  sha256 "f39241980244cb97fccb11ef3aac6b6deb9c6cfbcf1253e1280f18499c43e739"
  license "MIT"
  head "https://github.com/IBDecodable/IBLinter.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "317e711f65b4a62562f8d32834cbd1c7c0a20fca44c5d3f9cc34974848a5a1e2" => :catalina
    sha256 "7bbba8112111c1923eb9a2e0234d0630aa20a0f9fa34944260e4951f291ff9ba" => :mojave
  end

  depends_on :xcode => ["10.2", :build]

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Test by showing the help scree
    system "#{bin}/iblinter", "help"

    # Test by linting file
    (testpath/".iblinter.yml").write <<~EOS
      ignore_cache: true
      enabled_rules: [ambiguous]
    EOS

    (testpath/"Test.xib").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <document type="com.apple.InterfaceBuilder3.CocoaTouch.XIB" version="3.0" toolsVersion="14113" targetRuntime="iOS.CocoaTouch">
        <objects>
          <view key="view" id="iGg-Eg-h0O" ambiguous="YES">
            <rect key="frame" x="0.0" y="0.0" width="375" height="667"/>
          </view>
        </objects>
      </document>
    EOS

    assert_match "#{testpath}/Test.xib:0:0: error: UIView (iGg-Eg-h0O) has ambiguous constraints",
                 shell_output("#{bin}/iblinter lint --config #{testpath}/.iblinter.yml --path #{testpath}", 2).chomp
  end
end
