class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
     :tag      => "0.11.0",
     :revision => "0296f4df116385f868b67c5ffa7393936c3345c9"
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
    ldflags = %W[
      -s -w
      -X github.com/arduino/arduino-cli/version.versionString=#{version}
      -X github.com/arduino/arduino-cli/version.commit=#{commit}
    ]
    system "go", "build", *std_go_args, "-ldflags", ldflags
  end

  test do
    system "#{bin}/arduino-cli", "sketch", "new", "test_sketch"
    assert File.directory?("#{testpath}/test_sketch")
  end
end
