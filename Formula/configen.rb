class Configen < Formula
  desc "Configuration file code generator for use in Xcode projects"
  homepage "https://github.com/theappbusiness/ConfigGenerator"
  url "https://github.com/theappbusiness/ConfigGenerator/archive/1.1.2.tar.gz"
  sha256 "24a0d51f90b36d56c2f75ced9653cf34fe396fd687305903b31eeb822d520608"
  license "MIT"
  head "https://github.com/theappbusiness/ConfigGenerator.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "78a7c0604f2a98b2f488b2bfefebff47e08342e69d5f47b7123f15f71bcb9653" => :big_sur
    sha256 "d7aa87ea082759093c1192bf7e0ee69c1146ef4626534731ff506a83ec682641" => :arm64_big_sur
    sha256 "9bdb2988618d5a1e9291a8579207d9dad1092f377d29d13af68cf6ef5afcb202" => :catalina
    sha256 "befb8801be997ff110c9ca0b817fed82b4e233842f5afe05e7ae372a10c4007f" => :mojave
  end

  depends_on xcode: ["10.2", :build]

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
