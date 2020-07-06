class Bluepill < Formula
  desc "Testing tool for iOS that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill.git",
    :tag      => "v5.2.4.1",
    :revision => "b9e87eff54470fc6dc290cfefe80fc3486a06a1a"
  license "BSD-2-Clause"
  head "https://github.com/linkedin/bluepill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f026badf5c5ded4b903de74382012e9b90a7b8fc1c5745ad2552fd937714b763" => :catalina
    sha256 "6782b815d7d64190194460589adc6d790ebf4265ceeab8f869ff915a658d0aad" => :mojave
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
