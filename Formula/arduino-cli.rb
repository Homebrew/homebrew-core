class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
      tag:      "0.25.1",
      revision: "436f0bb9148bf309ffc980a36578caf080eeaec9"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb56ffdc8770bd516514b01e6d37e1478657553893dd01024ea4cfae369f9818"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84d2f4ecacbfead666b32bbb146a2b356352d3bcff1c392b70abe5dfe0259c61"
    sha256 cellar: :any_skip_relocation, monterey:       "2252bd32bb00cd26254cb7750f82d01337d414fbb5ae305a60a611c7aaea5a1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf45fdf32b7021561a9d83f123d45211cd32e323b8261b16dbdbcae6feea3395"
    sha256 cellar: :any_skip_relocation, catalina:       "6ead344696fceb05d68995acdcfbb079d19e13de2a959d09404007c56f5e9e03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd43ff4f1a7a5ec08143e7b34f94d788b50324610a02672e942d6e048c09ebc2"
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
