class Iblinter < Formula
  desc "Linter tool for Interface Builder"
  homepage "https://github.com/IBDecodable/IBLinter"
  url "https://github.com/IBDecodable/IBLinter/archive/0.4.27.tar.gz"
  sha256 "1403d4b104d41a8cfbc66b8533b53f1f94255f00904dfb97e91a88230f07dcfc"
  license "MIT"
  head "https://github.com/IBDecodable/IBLinter.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac6b0a40f7cad78d4afef1dd7c874356fbf870275349aecb82de7733d620f958"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8b7e60ab04bde225bb1a598f48f816a3672ae079262438de162678e2802e48d"
    sha256 cellar: :any_skip_relocation, monterey:       "a42624bde4bddb39236ac2261b75cd118afeca63fabfd40bd23fd6220115cb77"
    sha256 cellar: :any_skip_relocation, big_sur:        "01a92d21d4bcafd3f50d095be30903dddbc6abfea1d05b2535a2d2b8a86d5048"
    sha256 cellar: :any_skip_relocation, catalina:       "d1f695ee4af2122773fb1d5113cbc1ffc18520da4267a051ed275e3b01ff326d"
    sha256 cellar: :any_skip_relocation, mojave:         "c8c64fb3319c716d4cd0d69cc383b1ae6c152112093eeaad5e7ee9aa07c50f20"
  end

  depends_on xcode: ["10.2", :build]

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
