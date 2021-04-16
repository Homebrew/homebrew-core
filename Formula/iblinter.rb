class Iblinter < Formula
  desc "Linter tool for Interface Builder"
  homepage "https://github.com/IBDecodable/IBLinter"
  url "https://github.com/IBDecodable/IBLinter/archive/0.4.26.tar.gz"
  sha256 "2297387aec09d9da9321118e75a50235e1df53c22826e4ac664784680908c21e"
  license "MIT"
  head "https://github.com/IBDecodable/IBLinter.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "eab89051e8c6e072b9cc757ed6bb5247dcdb3fde229a73af905d90d5fed06c32"
    sha256 cellar: :any_skip_relocation, big_sur:       "83b2b578edbfb6af0a8ab6d5b893a41f946e0b4fd67e0eddc5a0bc6ad1846788"
    sha256 cellar: :any_skip_relocation, catalina:      "4bcb4abe5aa009da4353934fa804a55e2b88b40743e198108f55861749aa4af8"
    sha256 cellar: :any_skip_relocation, mojave:        "8846eaea01baa944e222217768747f9f80927349b0dfca5460e66fb0c34624e4"
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
