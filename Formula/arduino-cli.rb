class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
      tag:      "0.20.1",
      revision: "abb2144951a86092335adcbc45378a9e33a0879e"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9b99a472d7ea2324e5efa98d2ff74499e6f7b83dda59228f9cc27e8e00968ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c76d5f7f572f0ebbc96326b28c027f37a7cb439556883ac4afdaa765b3110110"
    sha256 cellar: :any_skip_relocation, monterey:       "f60eebd2304821b369dd5b261d720416187d8c0845756efcc8d996d48e678e32"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b9eb2bc7c3ec495cb3721073df4a74f847fee5eba1d2328e208fe1619845648"
    sha256 cellar: :any_skip_relocation, catalina:       "b4b991b4742bcb7acf3ea5ca4d6cffa641ad35195a867a94ff8df3a201fe74c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9744fd0a4f0c5fa1a161b45ce249fdbde07a8e430cbbc44694dc688e11b1260"
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
