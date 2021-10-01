class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
      tag:      "0.19.2",
      revision: "991a2649f2fa5114f7abbcc0db69b63a61ee7ef7"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8e794eaa6db5e79a35946f5bf8615ba6f48f78fca948ce4d0425a6a578b43f57"
    sha256 cellar: :any_skip_relocation, big_sur:       "e2a65d67dd29be70fb79161004015b0c41890e356d215cea377c0d5738f64f24"
    sha256 cellar: :any_skip_relocation, catalina:      "5a728a8659667494694d8e972a1c4b57d6b293e4cc00ad5f910d86f95de0f469"
    sha256 cellar: :any_skip_relocation, mojave:        "efe9bc91ee79dcba3e2175383d0c544b1f8b351c8fc86da8cc77a23a6461a084"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6873b14d4c68f4c12f60aa625dd434e3db5b3a804ca48c794961ea643ab5262"
  end

  # Switch to Go 1.17 at version bump
  depends_on "go@1.16" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/arduino/arduino-cli/version.versionString=#{version}
      -X github.com/arduino/arduino-cli/version.commit=#{Utils.git_head(length: 8)}
      -X github.com/arduino/arduino-cli/version.date=#{time.iso8601}
    ].join(" ")
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
    assert_match("arduino-cli alpha Version: #{version}", version_output)
    assert_match("Commit:", version_output)
    assert_match(/[a-f0-9]{8}/, version_output)
    assert_match("Date: ", version_output)
    assert_match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z/, version_output)
  end
end
