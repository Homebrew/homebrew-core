class Configen < Formula
  desc "Configuration file code generator for use in Xcode projects"
  homepage "https://github.com/theappbusiness/ConfigGenerator"
  url "https://github.com/theappbusiness/ConfigGenerator/archive/1.1.2.tar.gz"
  sha256 "24a0d51f90b36d56c2f75ced9653cf34fe396fd687305903b31eeb822d520608"
  license "MIT"
  head "https://github.com/theappbusiness/ConfigGenerator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c460c8a01dbdd8cccb66749dea6543bb63430129ea4717ecc9a03e27b6674bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a677709fb477a2e97d7791393044062418f5143928cf69d2d373e075c1209cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7aa87ea082759093c1192bf7e0ee69c1146ef4626534731ff506a83ec682641"
    sha256 cellar: :any_skip_relocation, ventura:        "ef53a9ef9dc4b97d7d735ba7b75663734b4f4d84020610ffb724bb3bd2ceaafb"
    sha256 cellar: :any_skip_relocation, monterey:       "3fde28a899b11fd837c3d30b27b26485a1e33f7bf951fe469d7fe8ea6ec41e0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "78a7c0604f2a98b2f488b2bfefebff47e08342e69d5f47b7123f15f71bcb9653"
    sha256 cellar: :any_skip_relocation, catalina:       "9bdb2988618d5a1e9291a8579207d9dad1092f377d29d13af68cf6ef5afcb202"
    sha256 cellar: :any_skip_relocation, mojave:         "befb8801be997ff110c9ca0b817fed82b4e233842f5afe05e7ae372a10c4007f"
  end

  depends_on xcode: ["10.2", :build]
  depends_on :macos

  def install
    xcodebuild "-arch", Hardware::CPU.arch, "SYMROOT=build"
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
