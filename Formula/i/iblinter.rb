class Iblinter < Formula
  desc "Linter tool for Interface Builder"
  homepage "https://github.com/IBDecodable/IBLinter"
  url "https://github.com/IBDecodable/IBLinter/archive/refs/tags/0.5.0.tar.gz"
  sha256 "d1aafdca18bc81205ef30a2ee59f33513061b20184f0f51436531cec4a6f7170"
  license "MIT"
  revision 2
  head "https://github.com/IBDecodable/IBLinter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1e66ec7fdee3ae5b454e67336ba833cfcafe29417fc976c6a7a09fe4874a6893"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "edfa9a0703e03c81df343d462d2c33c87742c1d38047a7bbe26366a78d21c394"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b88dff6dcb1898da9fc0f4270d88a60cbc1fcb6e639ceb8d94c7bfb9e228008f"
    sha256                               arm64_linux:       "895973d1b3ddb94bb99ec7fae5321bde3a12512d6ad1f6b1f69b4c1f3ee26302"
    sha256                               x86_64_linux:      "682df528a5c33efbf78869d3d51e60f98417bba4fe759767ec75c32603cac632"
  end

  uses_from_macos "swift"

  on_macos do
    depends_on xcode: ["10.2", :build]
  end

  # Fetch a copy of SourceKitten in order to fix build with newer Swift.
  # TODO: remove when fixed: https://github.com/IBDecodable/IBLinter/issues/189
  resource "SourceKitten" do
    # https://github.com/IBDecodable/IBLinter/blob/0.5.0/Package.resolved#L41-L47
    url "https://github.com/jpsim/SourceKitten.git",
        tag:      "0.29.0",
        revision: "77a4dbbb477a8110eb8765e3c44c70fb4929098f"

    # Backport of import from HEAD
    patch :DATA
  end

  deny_network_access!

  def fetch
    (buildpath/"SourceKitten").install resource("SourceKitten")
    system "swift", "package", "--disable-sandbox", "edit", "SourceKitten", "--path", buildpath/"SourceKitten"
    system "swift", "package", "--disable-sandbox", "resolve"
  end

  def install
    args = ["--disable-sandbox", "--configuration", "release"]

    system "swift", "build", *args
    bin.install ".build/release/iblinter"
  end

  test do
    # Test by showing the help scree
    system bin/"iblinter", "help"

    # Test by linting file
    (testpath/".iblinter.yml").write <<~YAML
      ignore_cache: true
      enabled_rules: [ambiguous]
    YAML

    (testpath/"Test.xib").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <document type="com.apple.InterfaceBuilder3.CocoaTouch.XIB" version="3.0" toolsVersion="14113" targetRuntime="iOS.CocoaTouch">
        <objects>
          <view key="view" id="iGg-Eg-h0O" ambiguous="YES">
            <rect key="frame" x="0.0" y="0.0" width="375" height="667"/>
          </view>
        </objects>
      </document>
    XML

    assert_match "#{testpath}/Test.xib:0:0: error: UIView (iGg-Eg-h0O) has ambiguous constraints",
                 shell_output("#{bin}/iblinter lint --config #{testpath}/.iblinter.yml --path #{testpath}", 2).chomp
  end
end

__END__
diff --git a/Source/SourceKittenFramework/SwiftDocs.swift b/Source/SourceKittenFramework/SwiftDocs.swift
index 1d2473c..70de287 100644
--- a/Source/SourceKittenFramework/SwiftDocs.swift
+++ b/Source/SourceKittenFramework/SwiftDocs.swift
@@ -10,6 +10,14 @@
 import SourceKit
 #endif

+#if os(Linux)
+import Glibc
+#elseif os(Windows)
+import CRT
+#else
+import Darwin
+#endif
+
 /// Represents docs for a Swift file.
 public struct SwiftDocs {
     /// Documented File.
