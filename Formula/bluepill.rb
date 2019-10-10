class Bluepill < Formula
  desc "iOS testing tool that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill.git",
    :tag => "v5.0.0"
  sha256 "9b147ccd040449f9a2a47c8cc884819eae098d93f7e987dce259982a729fd136"
  head "https://github.com/linkedin/bluepill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "38bc9c743a3b614059e474d91da2f19ad88746bd8057370d2bbcf49953eb4313" => :mojave
    sha256 "9e4506d2c52ac67e48f87a77352a3fd8ec270fa68ddf82e60751589442d2d498" => :high_sierra
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
