class Eject < Formula
  desc "Generate swift code from Interface Builder xibs"
  homepage "https://github.com/Raizlabs/Eject"
  url "https://github.com/Raizlabs/Eject/archive/0.1.27.tar.gz"
  sha256 "b4aa8d281074074632422e9e8583d50024f1b2712566fae7950e73f751f75791"

  bottle do
    cellar :any
    sha256 "71d2de28a1d21a94568f2f4d63f82d15da5187433d86a4718727538a78b34de1" => :mojave
    sha256 "3333db5dbcaba9ec034423be274f92465fd4058ee3322c9278e783090cc172d2" => :high_sierra
    sha256 "ae124f2e438fe9bf83900b2f5f452d478ff2ca8b9a36dcd07454497044e4ae49" => :sierra
    sha256 "37fd3d134428952fda16239392f4960428852c1f83eb942bd0b45da2e76dcc3b" => :el_capitan
  end

  depends_on :xcode => ["8.0", :build]

  def install
    xcodebuild "SYMROOT=build"
    bin.install "build/Release/eject.app/Contents/MacOS/eject"
    frameworks_path = "build/Release/eject.app/Contents/Frameworks"
    mv frameworks_path, frameworks
  end

  test do
    (testpath/"view.xib").write <<~EOS
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

    swift = <<~EOS
      // Create Views
      let view = UIView()
      view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
      view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    EOS

    assert_equal swift, shell_output("#{bin}/eject --file view.xib")
  end
end
