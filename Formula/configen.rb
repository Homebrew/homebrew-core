class Configen < Formula
  desc "Configuration file code generator for use in Xcode projects"
  homepage "https://github.com/theappbusiness/ConfigGenerator"
  url "https://github.com/theappbusiness/ConfigGenerator/archive/1.1.1.tar.gz"
  sha256 "bc35ff0970c9d892a9c9e762f9a6bc63d222d3556cec924e9292f517ac22339d"
  head "https://github.com/theappbusiness/ConfigGenerator.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "76704af2cc733f86ba8d34fc07631c86747122a6ccaf6b364cb63ede5c3d2967" => :catalina
    sha256 "223e51be5329aa59259f47e86efb076ded7813351611145ce7705caaa3f8a526" => :mojave
    sha256 "70230a42b9feb0fc33a7c6331a1835bdc414f0f356cb705b0ee69645a624c087" => :high_sierra
    sha256 "ecc6949d99f9a8843f85450bac723d11e4efb9c65430d669e191a0aaf1d2c0e7" => :sierra
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
