class Bluepill < Formula
  desc "iOS testing tool that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill.git",
    :tag => "v5.1.1", :revision => "065f4b325f513ea32b3c9be8885ba073bbacaeca"
  head "https://github.com/linkedin/bluepill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "71520ac31630ea14f2878d72ba29aa910c3bd0dcf3db1bb606bb017260fe9c52" => :catalina
    sha256 "8628c006805fc4ed2ba77b9529499f1fa6d59dad499a191efa811b8c9f8fed99" => :mojave
  end

  depends_on :xcode => ["11.2", :build]

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
