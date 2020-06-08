class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
     :tag      => "0.10.0",
     :revision => "ec5c3ed105b32c5654fd60131a667f8557b196d5"
  head "https://github.com/arduino/arduino-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "20caaeca7ed89e87bacd355e84ff2861917aad6044004ad29827d607dbcaf61d" => :catalina
    sha256 "4b2467f1802f4fbc44c2dc96e25cf778f61179d6610730bf2be092005f6423d4" => :mojave
    sha256 "b310e9dc896318a5b95e2f24506a6f23637d544dd0d51efe7d70f492c4db69b7" => :high_sierra
  end

  depends_on "go" => :build

  def install
    commit = Utils.safe_popen_read("git", "rev-parse", "HEAD").chomp
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
