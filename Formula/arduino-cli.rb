class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
     :tag      => "0.7.1",
     :revision => "7668c465dd0ed58059c51b1b1f0a06279d6f4714"
  head "https://github.com/arduino/arduino-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0835662d46d398023c261eec483971212fac329520bca44a44d8176f0f19c400" => :mojave
    sha256 "0cb274e5f12c438d4a1808b2905f5af16055d440dc90ee4d1eabdb16cdc81c74" => :high_sierra
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
