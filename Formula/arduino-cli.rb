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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c5b440af68597c335014f1af418f2ea7b18a71eeae8eff50f15972642c296507"
    sha256 cellar: :any_skip_relocation, big_sur:       "62fbd34ab3cc8fdb36699aedeba55b156981ce3bac5af3b2fc126d4b245f756f"
    sha256 cellar: :any_skip_relocation, catalina:      "7e7ed5fa0d59083c8d84731b0396266da843b9fca24c94ea4cea404be4909831"
    sha256 cellar: :any_skip_relocation, mojave:        "b0ca98cccef2f4b5b14baefa104514023a9142035f0f75937bc0a06d1926dd5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e18c5bf41053c43af9fe17ecd7a47b4fcb2b910c928e602260e09026e17650c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/arduino/arduino-cli/version.versionString=#{version}
      -X github.com/arduino/arduino-cli/version.commit=#{Utils.git_head(length: 8)}
      -X github.com/arduino/arduino-cli/version.date=#{time.iso8601}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags)

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
