class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
     tag:      "0.18.2",
     revision: "7b5a22a463c14b8891b28048a6a7af52acd4cac0"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "5fe50c0317f742d69cd599bbc6a47c2c8ced9b4bc26528d2d43ceef0b27f2644"
    sha256 cellar: :any_skip_relocation, catalina: "19c32a1f88223b1ee5b5a0535796c4ef7b20d6d024ebfe5d3c1c96eba01981f1"
    sha256 cellar: :any_skip_relocation, mojave:   "ddd9fc9fd36b72c32f5f197411cf44a26da821af32aac69e52cb2ec276d2aa99"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/arduino/arduino-cli/version.versionString=#{version}
      -X github.com/arduino/arduino-cli/version.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args, "-ldflags", ldflags.join(" ")

    output = Utils.safe_popen_read({ "SHELL" => "bash" }, "#{bin}/arduino-cli", "completion", "bash")
    (bash_completion/"arduino-cli").write output

    output = Utils.safe_popen_read({ "SHELL" => "zsh" }, "#{bin}/arduino-cli", "completion", "zsh")
    (zsh_completion/"_arduino-cli").write output

    output = Utils.safe_popen_read({ "SHELL" => "fish" }, "#{bin}/arduino-cli", "completion", "fish")
    (fish_completion/"arduino-cli.fish").write output
  end

  test do
    system "#{bin}/arduino-cli", "sketch", "new", "test_sketch"
    assert File.directory?("#{testpath}/test_sketch")

    version_output = shell_output("#{bin}/arduino-cli version 2>&1")
    assert_match "arduino-cli alpha Version: #{version}", version_output
  end
end
