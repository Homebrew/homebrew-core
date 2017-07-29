class Libtelnet < Formula
  desc "Apple libtelnet built from macOS 10.12.4 sources"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/libtelnet/libtelnet-13.tar.gz"
  sha256 "e7d203083c2d9fa363da4cc4b7377d4a18f8a6f569b9bcf58f97255941a2ebd1"

  depends_on :xcode => :build
  depends_on :macos => :high_sierra

  def install
    xcodebuild "SYMROOT=build"

    lib.install "build/Release/libtelnet.a"
    include.install "build/Release/usr/local/include/libtelnet/"
  end

  test do
    output = shell_output("file /usr/local/lib/libtelnet.a")
    assert_match "Mach-O universal binary", output
    assert_match "x86_64", output
    assert_match "i386", output
  end
end
