class Eject < Formula
  desc "Generate swift code from Interface Builder xibs"
  homepage "https://github.com/Raizlabs/Eject"
  url "https://github.com/Raizlabs/Eject/archive/0.1.25.tar.gz"
  sha256 "9b6796c0517e516bdf606aec1d039416cf515a07f53e37efb833fe1960b925c3"

  bottle do
    cellar :any
    sha256 "29935f7e50a2b17fbd8f8d36fd7b7f0537bf1fa90ef14d3072440a3fb804c28b" => :sierra
    sha256 "3ebf7bc96c930a0877cded9d549e57305940a85aff0df1ad497490ef161f79fb" => :el_capitan
  end

  depends_on :xcode => ["8.0", :build]

  def install
    xcodebuild
    bin.install "build/Release/eject.app/Contents/MacOS/eject"
    frameworks_path = "build/Release/eject.app/Contents/Frameworks"
    mv frameworks_path, frameworks
  end

  test do
    (testpath/"view.xib").write <<-EOS.undent
      <?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <document type="com.apple.InterfaceBuilder3.CocoaTouch.XIB" version="3.0" toolsVersion="11134" systemVersion="15F34" targetRuntime="iOS.CocoaTouch" propertyAccessControl="none" useAutolayout="YES" useTraitCollections="YES" colorMatched="YES">
          <dependencies>
              <plugIn identifier="com.apple.InterfaceBuilder.IBCocoaTouchPlugin" version="11106"/>
              <capability name="documents saved in the Xcode 8 format" minToolsVersion="8.0"/>
          </dependencies>
          <objects>
              <placeholder placeholderIdentifier="IBFilesOwner" id="-1" userLabel="File's Owner"/>
              <placeholder placeholderIdentifier="IBFirstResponder" id="-2" customClass="UIResponder"/>
              <view contentMode="scaleToFill" id="iN0-l3-epB">
                  <rect key="frame" x="0.0" y="0.0" width="375" height="667"/>
                  <autoresizingMask key="autoresizingMask" widthSizable="YES" heightSizable="YES"/>
                  <color key="backgroundColor" red="1" green="1" blue="1" alpha="1" colorSpace="custom" customColorSpace="sRGB"/>
              </view>
          </objects>
      </document>
    EOS

    swift = <<-EOS.undent
      // Create Views
      let view = UIView()
      view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
      view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    EOS

    assert_equal swift, shell_output("#{bin}/eject --file view.xib")
  end
end
