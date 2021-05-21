class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
     tag:      "0.18.3",
     revision: "d710b642ef7992a678053e9d68996c02f5863721"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/arduino/arduino-cli.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "05baaf3eb15992dd6f4fc1d664afff61b3ae9f68136bce0d704813eadafc1fa8"
    sha256 cellar: :any_skip_relocation, big_sur:       "698b89996bbb1a67f26e4344fdd1b5f8993f59f14c8cb774309938ed4fac4ebc"
    sha256 cellar: :any_skip_relocation, catalina:      "2980a7274dccb3ca12c2ca7a54696a2cf8fd086a93edebdee363f75f7c0e1ffa"
    sha256 cellar: :any_skip_relocation, mojave:        "5cea6da20a71ee40a617e54fa52a0e64951acdc4bbf216bbd7bbc954fee924b1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/arduino/arduino-cli/version.versionString=#{version}
      -X github.com/arduino/arduino-cli/version.commit=#{Utils.git_head(length: 8)}
      -X github.com/arduino/arduino-cli/version.date=#{Time.now.utc.iso8601}
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
    assert_match("arduino-cli alpha Version: #{version}", version_output)
    assert_match("Commit:", version_output)
    assert_match(/[a-f0-9]{8}/, version_output)
    assert_match("Date: ", version_output)
    assert_match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z/, version_output)
  end
end
