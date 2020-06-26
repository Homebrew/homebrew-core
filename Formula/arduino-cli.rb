class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
     :tag      => "0.11.0",
     :revision => "0296f4df116385f868b67c5ffa7393936c3345c9"
  head "https://github.com/arduino/arduino-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a8049eed8d57096c6fa53c9e2555f686a3f29b622de099433c85b2b24787637" => :catalina
    sha256 "c215a2743e597c19c1252ea977f5bc0936964380544d69b0079473ba6a09d95b" => :mojave
    sha256 "48ab865e380a27c8abc1e661969e1382d44be37bcec31409c5c0546d5e617637" => :high_sierra
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
