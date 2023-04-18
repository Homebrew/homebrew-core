class Iblinter < Formula
  desc "Linter tool for Interface Builder"
  homepage "https://github.com/IBDecodable/IBLinter"
  url "https://github.com/IBDecodable/IBLinter/archive/0.5.0.tar.gz"
  sha256 "d1aafdca18bc81205ef30a2ee59f33513061b20184f0f51436531cec4a6f7170"
  license "MIT"
  head "https://github.com/IBDecodable/IBLinter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7feaf0f8989fa59389fb0788d91688ea5cac2ffeed12ee872aace5110f7bf8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83ffc3e0bd87735dce4868ce4540fb025d94c8a491e6b029d537f7594d653935"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1022dcabaa9a097c554000519d2ba6c424d7612a6cb344c8b2697477f7f40e2a"
    sha256 cellar: :any_skip_relocation, ventura:        "63bd9e8532fa5e7b741e5ba07952ca62a51e1c14608f15c90871093b28664e6e"
    sha256 cellar: :any_skip_relocation, monterey:       "c29c85d68c136f5c706167c47c79092facfbc4a5b02956233ea6d8617ac6aa05"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa478f72715391c8e25e31ead3a9b25503158eb37a6d4d4ae5ab222f5026c13a"
    sha256 cellar: :any_skip_relocation, catalina:       "558920fbd33ed70ba3ebe56543756dc51fbece752be655691e46ac33b8bec8e0"
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
