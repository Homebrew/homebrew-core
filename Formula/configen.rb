class Configen < Formula
  desc "Configuration file code generator for use in Xcode projects"
  homepage "https://github.com/theappbusiness/ConfigGenerator"
  url "https://github.com/theappbusiness/ConfigGenerator/archive/1.1.1.tar.gz"
  sha256 "bc35ff0970c9d892a9c9e762f9a6bc63d222d3556cec924e9292f517ac22339d"
  head "https://github.com/theappbusiness/ConfigGenerator.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "82e930bb4d70ee9a6e5d992369be4752f6fed2ddb24d32e55e1deafb32552f66" => :catalina
    sha256 "1eba1c4035e8bd429023f782d093cbb98dae2c7d4f6a876640afdddc8aaef9e2" => :mojave
  end

  depends_on :xcode => ["10.2", :build]

  def install
    xcodebuild "SYMROOT=build"
    bin.install "build/Release/configen"
  end

  test do
    (testpath/"test.plist").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>testURL</key>
        <string>https://example.com/api</string>
        <key>retryCount</key>
        <integer>2</integer>
      </dict>
      </plist>
    EOS
    (testpath/"test.map").write <<~EOS
      testURL : URL
      retryCount : Int
    EOS
    system bin/"configen", "-p", "test.plist", "-h", "test.map", "-n", "AppConfig", "-o", testpath
    assert_predicate testpath/"AppConfig.swift", :exist?, "Failed to create config class!"
    assert_match "static let testURL: URL = URL(string: \"https://example.com/api\")", File.read("AppConfig.swift")
    assert_match "static let retryCount: Int = 2", File.read("AppConfig.swift")
  end
end
