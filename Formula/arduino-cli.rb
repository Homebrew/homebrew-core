class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
      tag:      "0.21.0",
      revision: "10107d2407c2d9997310fc2e0f22dfd15d48e9a8"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d72365f744423ec90aca3ac2cfeb8a55141f4684220692ddcfb88dd364f5920"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96e5a028909e179c575f095df5281de7835fa4ccefb37e82ea66d194e9e29e7e"
    sha256 cellar: :any_skip_relocation, monterey:       "4fa06e0079d3604ed1dc0dc350caa90e2a96645bce143a7289a4bbce6c1e9bd4"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b8473450ffb79a14418b761d06e78b2675668cbc72069ddad31dd631805c2e1"
    sha256 cellar: :any_skip_relocation, catalina:       "9a1b95d37fa82fcd4bb626353d1e2c9285e77cb34c865b426345d26be1ad499e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94880ff37355df809065540d56841a29c75a61a3c947908adb77174022168f86"
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
