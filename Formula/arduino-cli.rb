class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
      tag:      "0.26.0",
      revision: "fc2ea72362c63b0f870c29cc31138c0a21006621"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34c4be7da446500627e24548ef3ef65cc06f380854243318b337403ac8bb6465"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d579cf73d8a218a713f3834a40ce18feda6f68b92790e464e6c19afb9cb65d64"
    sha256 cellar: :any_skip_relocation, monterey:       "5bdf9bddfa54b29d1ef51bc7b9507c22f7b545130426907a00df6dce8acd74ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3507e560d1e70a0865f4c4b81f82e1d8d82880ef4eaa86f3edfbcc7f8666d90"
    sha256 cellar: :any_skip_relocation, catalina:       "f5b73f34c92c010304f0f83372b0defeca97cccfba51e16756314e7bc5ce0c05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5276d93b97432cb627474520eafd08976c3a87d4850eac0baec7be5973be11d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/arduino/arduino-cli/version.versionString=#{version}
      -X github.com/arduino/arduino-cli/version.commit=#{Utils.git_head(length: 8)}
      -X github.com/arduino/arduino-cli/version.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    output = Utils.safe_popen_read(bin/"arduino-cli", "completion", "bash")
    (bash_completion/"arduino-cli").write output

    output = Utils.safe_popen_read(bin/"arduino-cli", "completion", "zsh")
    (zsh_completion/"_arduino-cli").write output

    output = Utils.safe_popen_read(bin/"arduino-cli", "completion", "fish")
    (fish_completion/"arduino-cli.fish").write output
  end

  test do
    system "#{bin}/arduino-cli", "sketch", "new", "test_sketch"
    assert File.directory?("#{testpath}/test_sketch")

    version_output = shell_output("#{bin}/arduino-cli version 2>&1")
    assert_match("arduino-cli  Version: #{version}", version_output)
    assert_match("Commit:", version_output)
    assert_match(/[a-f0-9]{8}/, version_output)
    assert_match("Date: ", version_output)
    assert_match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z/, version_output)
  end
end
