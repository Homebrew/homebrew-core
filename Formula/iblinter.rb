class Iblinter < Formula
  desc "Linter tool for Interface Builder"
  homepage "https://github.com/IBDecodable/IBLinter"
  url "https://github.com/IBDecodable/IBLinter/archive/0.4.24.tar.gz"
  sha256 "03a210e3adf22f93b3501ee5b69ead2e127e161e5ae8c4cec0aefd970aef958e"
  license "MIT"
  head "https://github.com/IBDecodable/IBLinter.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c1ef57667d9068b21544871f750357897b123e3d6e329982ad06f96affb2c15" => :catalina
    sha256 "0a7c93d98d2f992934b88700d3ee0a203d575c65cd58786163fdab9fd209c0a0" => :mojave
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
