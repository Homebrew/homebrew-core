class Bluepill < Formula
  desc "Testing tool for iOS that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill.git",
    :tag => "v5.2.2", :revision => "89010caaff60e75e23d612d3d60a1efd7b2e2b99"
  head "https://github.com/linkedin/bluepill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d8201309948fc200574f9a9163ea7ae4db671ccf68765d38612e17d5c2ad119" => :catalina
    sha256 "e700c4f5b4dfd82ced61285451923c04f1614412ec190a45f4af4eb6c8769b27" => :mojave
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
