class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
     tag:      "0.14.0",
     revision: "a86b21d99e2af9e0857da0ce4ab80baf1d3afb55"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f5bf7e8be260422b006a669efd8440d7aa07e7c8e00d79988c14bb8edc0ee28d" => :big_sur
    sha256 "b5927718821674c171e8853f97c83331216bea92257168e1bd4e830fe88d5e58" => :catalina
    sha256 "4522d66a123be600d11f7c7b76dbc327f139cc060564c920fcf7c1d888a07ede" => :mojave
    sha256 "fc4945e6f995a7367d807edcb31708a2d5d7d82cfec22b26b1187133db40b8a6" => :high_sierra
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
