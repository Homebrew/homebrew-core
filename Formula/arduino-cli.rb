class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
     :tag      => "0.5.0",
     :revision => "3be22875e27f220350d8ab5b13403d804acfd20b"
  head "https://github.com/arduino/arduino-cli.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e65612c215ea053f4b19fae9d243f5a28cbd467549eef4a3fb3f11c66b7e977a" => :catalina
    sha256 "485320b786380d4a7fc18fe0d3251b5541f51ea79f65438596749fd0478f87ec" => :mojave
    sha256 "afa5030f20097880956596e04d76bb4efab028b67a6cd5f19d7b89a01039bc14" => :high_sierra
  end

  depends_on "go" => :build

  def install
    commit = Utils.popen_read("git", "rev-parse", "HEAD").chomp
    system "go", "build", "-ldflags", "-s -w -X github.com/arduino/arduino-cli/version.versionString=#{version} -X github.com/arduino/arduino-cli/version.commit=#{commit}", "-o", bin/"arduino-cli"
  end

  test do
    system "#{bin}/arduino-cli", "sketch", "new", "test_sketch"
    assert File.directory?("#{testpath}/Documents/Arduino/test_sketch")
  end
end
