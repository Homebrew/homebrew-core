class Configen < Formula
  desc "Configuration file code generator for use in Xcode projects"
  homepage "https://github.com/theappbusiness/ConfigGenerator"
  url "https://github.com/theappbusiness/ConfigGenerator/archive/v1.0.0.tar.gz"
  sha256 "b44b18df31a6a0bb2e5e44db48f26c7bba504a9b78d56fdf6a3bc543d79c2850"

  head "https://github.com/theappbusiness/ConfigGenerator.git"

  depends_on :xcode => :build

  def install
    xcodebuild "SYMROOT=build"
    bin.install "build/Release/configen"
  end

  test do
    (testpath/"test.plist").write <<-EOS.undent
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>testURL</key>
        <string>http://example.com/api</string>
        <key>retryCount</key>
        <integer>2</integer>
      </dict>
      </plist>
    EOS
    (testpath/"test.map").write <<-EOS.undent
      testURL : URL
      retryCount : Int
    EOS
    system bin/"configen", "-p", "test.plist", "-h", "test.map", "-n", "AppConfig", "-o", testpath
    assert_predicate testpath/"AppConfig.swift", :exist?, "Failed to create config class!"
    assert_match "static let testURL: URL = URL(string: \"http://example.com/api\")", File.read("AppConfig.swift")
    assert_match "static let retryCount: Int = 2", File.read("AppConfig.swift")
  end
end
