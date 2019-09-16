class Configen < Formula
  desc "Configuration file code generator for use in Xcode projects"
  homepage "https://github.com/theappbusiness/ConfigGenerator"
  url "https://github.com/theappbusiness/ConfigGenerator/archive/1.1.0.tar.gz"
  sha256 "3bd03adbd82cd94a610b07fbc3e9fb8e5aca35f938c891fa69db9eec9411331b"
  head "https://github.com/theappbusiness/ConfigGenerator.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6e24d78837317e8e116d9389d3fddc3eac12d4eab8ab35f7b34a7a187a68fbe0" => :mojave
    sha256 "7c646347aa05959b8177bc2bb3e4353069e0c6e974c8c4b8720bb96ac02f047a" => :high_sierra
    sha256 "5b131b852ac49d25f9d6d59880b3d92323ae918a9136d26e05506a8835613b2f" => :sierra
  end

  depends_on :xcode => ["9.0", :build]

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
