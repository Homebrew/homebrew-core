class Configen < Formula
  desc "Configuration file code generator for use in Xcode projects"
  homepage "https://github.com/theappbusiness/ConfigGenerator"
  url "https://github.com/theappbusiness/ConfigGenerator/archive/v1.0.1.tar.gz"
  sha256 "ade2c4296643cbc0c21d989d4506eef9d797a0349300ff46590a6b47979cdf64"

  head "https://github.com/theappbusiness/ConfigGenerator.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "be9ec3b8d83dff7865f15c3171be2df9bdff904e2a66e9e4902d2bbb0a3ef12c" => :high_sierra
    sha256 "845540be7277a39c5db5d8a26d800c3009bae1d05fd5528dc55d8893efb1274c" => :sierra
    sha256 "f7ff48ab3a47cffc90001fa888e53a0d520327bb68285ee9d8dbe9a3355c1118" => :el_capitan
  end

  depends_on :xcode => ["9.0", :build]

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
