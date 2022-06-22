class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
      tag:      "0.24.0",
      revision: "c1b10f562f1e1a112e215a69b84e2f2b69e3af2d"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e715b207fc2ba3cd20121af0024dcc7bd405340b73344ddb30596480057e1b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8f534879f0395a6f047a503b38b9bbd3053895aa0491842564e7b09a8e0c25c"
    sha256 cellar: :any_skip_relocation, monterey:       "68bcd66529253164fc50c39fe8e9adf894def8532da3dd69a558ebdfbc7b92db"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d8f93406aa9657cac75e5009e32465b152ea5e6612a9b14377036fb7646e8d8"
    sha256 cellar: :any_skip_relocation, catalina:       "6d60eb6eb72cb8b048e70174f17772262b29b47a6c2f7f142382046244ee6e85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d49c31432864c299f6f735f5f345702c6e1f48a9dcfca0c0b62ee55a761f74e7"
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
