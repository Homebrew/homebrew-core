class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
      tag:      "0.19.0",
      revision: "56419ecdd533e096439f554d80492a2426fed6a9"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bced5c9040397a8bac1a68d407331cf7cd27b8ad79514d9931f3e4c18873ae4c"
    sha256 cellar: :any_skip_relocation, big_sur:       "2f28e331cc9eece46ab63afbd580fa0c6ce55a62e4a598c9dc48970078c7440f"
    sha256 cellar: :any_skip_relocation, catalina:      "b7a6f3a9e843f5cbcba4410f7c345d2af498677a960343fc27b7c35f7b57ef07"
    sha256 cellar: :any_skip_relocation, mojave:        "2321ece4cf8dea0dd910c03c879cd5a8ac0a787f343da4c59b52fac28a5355c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75b518012a7b7effcb78e7ae232d823e3d8c4223c5a811795e6670e828789e7a"
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
