class Bluepill < Formula
  desc "iOS testing tool that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill/archive/v2.3.0.tar.gz"
  sha256 "437134b0a0ecf084df3edbb9d27da386e3f863ae52de0e5abce08f48ac781477"
  head "https://github.com/linkedin/bluepill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2adc4f65da1ef3d0b523acfad4264a0b7b7eb972dd902f59024eb4b5315e1578" => :high_sierra
    sha256 "07ed950f897b158185b7a43298372d1a20c1c8782f239a493a4f2f915bb09e44" => :sierra
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
