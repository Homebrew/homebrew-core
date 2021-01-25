class Iblinter < Formula
  desc "Linter tool for Interface Builder"
  homepage "https://github.com/IBDecodable/IBLinter"
  url "https://github.com/IBDecodable/IBLinter/archive/0.4.25.tar.gz"
  sha256 "8290148cdf48976f2cdda4070086fafbbb557b9352a95847a6f13dc6a0120aae"
  license "MIT"
  head "https://github.com/IBDecodable/IBLinter.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f9a3f72361babe22192ee13b018db825938a93bc735a4e577c8e6ceef36cadf" => :big_sur
    sha256 "a7f8d81e737bc81aebbe988e6c3056e215f9138ee3da42c546c993e1cbab604f" => :arm64_big_sur
    sha256 "c30f826110cae9b11d711b17d1ea2798e8fda1332acf85c1d39303e56e65fb3b" => :catalina
    sha256 "90a83ba6a62cdff672947d34182cc239688f3a11cd72343c2ce6745f42741dd2" => :mojave
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
