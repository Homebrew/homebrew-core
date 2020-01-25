class Iblinter < Formula
  desc "Linter tool for Interface Builder"
  homepage "https://github.com/IBDecodable/IBLinter"
  url "https://github.com/IBDecodable/IBLinter/archive/0.4.21.tar.gz"
  sha256 "cbf5a0abe08563f7f4151c0ed49fc86381b3ac284b65fc49496e44cae248d451"
  head "https://github.com/IBDecodable/IBLinter.git"

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
