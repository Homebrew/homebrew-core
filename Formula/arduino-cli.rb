class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
      tag:      "0.19.3",
      revision: "12f1afc2c1dee08d988974fe8f80e849f7ce4681"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "acd370bad88538a0bd0d1794c73551907ce9e4f11c22647af7f64194d93f65dc"
    sha256 cellar: :any_skip_relocation, big_sur:       "bbfe6d7d81eacbbb09f290d59fcd9502799674d7b0cf7ce08b978337068e4772"
    sha256 cellar: :any_skip_relocation, catalina:      "8c6d9630a7eff7b3e792c9a68243ae6930ba7f8bef45c61829ce66e1034df5e0"
    sha256 cellar: :any_skip_relocation, mojave:        "0b9cb6b74633c4104a4a96ae161fb4b85a1cef6dea45f53a3754fe1087df6f01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "730f0038f1746f4f923ddf5d578a350784f78319ec35858712d6d03083e8d07d"
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
