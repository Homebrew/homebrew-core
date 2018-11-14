class Bluepill < Formula
  desc "iOS testing tool that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill/archive/3.1.0.tar.gz"
  sha256 "9fe609d15cb6329df9cb02f1360b895e873f70816b13c2cb4c0ca6dd7641a9c5"
  head "https://github.com/linkedin/bluepill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b460d5f0820a12ffea15e816fd607314bd1f8120e388310a2cc433a79a1e629" => :mojave
    sha256 "2b0bad7f6565101df2d6fcc21acb7c744187b15466f86e5ca3d71f92bc3ec12e" => :high_sierra
  end

  depends_on :xcode => ["10.0", :build]

  def install
    xcodebuild "-workspace", "Bluepill.xcworkspace",
               "-scheme", "bluepill",
               "-configuration", "Release",
               "SYMROOT=../"
    bin.install "Release/bluepill", "Release/bp"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/bluepill -h")
    assert_match "Usage:", shell_output("#{bin}/bp -h")
  end
end
