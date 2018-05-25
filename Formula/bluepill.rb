class Bluepill < Formula
  desc "iOS testing tool that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill/archive/v2.3.1.tar.gz"
  sha256 "09d4e765b1721e325fa668536b2088053d6c4c84e199212c2532c4747e863293"
  head "https://github.com/linkedin/bluepill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c668c27d2d3997778bc14a4907778a78c9e16388ea24cd76267da59bd3a47f84" => :high_sierra
    sha256 "d9f036110b53653c779873fc9240e09be7c7c7adf3777b0aa0a816044c02a90f" => :sierra
  end

  depends_on :xcode => ["9.0", :build]

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
