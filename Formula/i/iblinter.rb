class Iblinter < Formula
  desc "Linter tool for Interface Builder"
  homepage "https://github.com/IBDecodable/IBLinter"
  url "https://github.com/IBDecodable/IBLinter/archive/refs/tags/0.5.0.tar.gz"
  sha256 "d1aafdca18bc81205ef30a2ee59f33513061b20184f0f51436531cec4a6f7170"
  license "MIT"
  revision 1
  head "https://github.com/IBDecodable/IBLinter.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ccc5cf7c9e37c007329b85160d1973f853444d151f027469f87501be2ce1dfd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d81bd417d74fbf2809e041c78801e8d83ea8b5e658519e459023197f1e1c3ffb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fba87c8a17f3b162579d58ae7bdb89bc015e7d4c7930d652c8826136767f2f0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5df5917b52968d0e5ae274fd7ed90a2740b0cefa51b04e59d1a736d4a3de86d0"
    sha256                               arm64_linux:   "f3d53ef7a5072cd59df9ff826df7809fac46dd2fc764f57ceefd22824640ff96"
    sha256                               x86_64_linux:  "c3a4dcb0445ce6cc30ee0d563919b23c5f7acd012cb83316d3f9a389343ad74c"
  end

  depends_on xcode: ["10.2", :build]

  uses_from_macos "swift"

  # Fetch a copy of SourceKitten in order to fix build with newer Swift.
  # Issue ref: https://github.com/IBDecodable/IBLinter/issues/189
  resource "SourceKitten" do
    on_system :linux, macos: :sonoma_or_newer do
      # https://github.com/IBDecodable/IBLinter/blob/0.5.0/Package.resolved#L41-L47
      url "https://github.com/jpsim/SourceKitten.git",
          tag:      "0.29.0",
          revision: "77a4dbbb477a8110eb8765e3c44c70fb4929098f"

      # Backport of import from HEAD
      patch :DATA
    end
  end

  def install
    args = ["--disable-sandbox", "--configuration", "release"]
    if !OS.mac? || MacOS.version >= :sonoma
      (buildpath/"SourceKitten").install resource("SourceKitten")
      system "swift", "package", *args, "edit", "SourceKitten", "--path", buildpath/"SourceKitten"
    end

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
