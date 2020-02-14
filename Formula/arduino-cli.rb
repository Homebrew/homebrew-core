class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
     :tag      => "0.8.0",
     :revision => "64c501da0f4c72c3dfadc081f7aa83cae99958c8"
  head "https://github.com/arduino/arduino-cli.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "629d73185427f52799755d484e9f59cd20aaadbe4ae0e78d4d0f4bf2c51c6297" => :catalina
    sha256 "ef3ff9245bd937ce7f879ba56277f54600d193e2f36b604bd1e827845b16c449" => :mojave
    sha256 "38616348a504a8740f5d5d21c5b94010bae230d386a2e5d330f5acac4c873c8f" => :high_sierra
  end

  depends_on "go" => :build

  def install
    commit = Utils.popen_read("git", "rev-parse", "HEAD").chomp
    system "go", "build", "-ldflags",
           "-s -w -X github.com/arduino/arduino-cli/version.versionString=#{version} " \
           "-X github.com/arduino/arduino-cli/version.commit=#{commit}",
           "-o", bin/"arduino-cli"
  end

  test do
    system "#{bin}/arduino-cli", "sketch", "new", "test_sketch"
    assert File.directory?("#{testpath}/test_sketch")
  end
end
