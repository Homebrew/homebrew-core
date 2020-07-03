class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
     :tag      => "0.11.0",
     :revision => "0296f4df116385f868b67c5ffa7393936c3345c9"
  revision 1
  head "https://github.com/arduino/arduino-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3dd10065c03827d1cc0a508daaf2787c154eda4bfc5378d671b17d16672bd293" => :catalina
    sha256 "4d176c41402ad7a3ceb8ad20ef4a621675c20bdb080b543193efddad07e7fc26" => :mojave
    sha256 "d885f46abbb996e64a47d8566677263bca7ca2cacfe78d8bd825d5a4bba02f38" => :high_sierra
  end

  depends_on "go" => :build

  def install
    commit = Utils.safe_popen_read("git", "rev-parse", "HEAD").chomp
    ldflags = %W[
      -s -w
      -X github.com/arduino/arduino-cli/version.versionString=#{version}
      -X github.com/arduino/arduino-cli/version.commit=#{commit}
    ]
    system "go", "build", *std_go_args, "-ldflags", ldflags.join(" ")
  end

  test do
    system "#{bin}/arduino-cli", "sketch", "new", "test_sketch"
    assert File.directory?("#{testpath}/test_sketch")
  end
end
