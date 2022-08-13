class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
      tag:      "0.26.0",
      revision: "fc2ea72362c63b0f870c29cc31138c0a21006621"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07495f6a3577b67024f034c9374e0249da5e4fd704e525ebdf85b1b39cf751f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cfc23333ed5e4256e96e29cee83f18d04f9908767b8f59db750fba1788d7226b"
    sha256 cellar: :any_skip_relocation, monterey:       "380fdb70772cca56ec0d4ab91fb82e02eaa5bd178f5fd051fe01f6c0f66c371a"
    sha256 cellar: :any_skip_relocation, big_sur:        "403304922d7634aafa4972ae28ce8791cfc9f04312ef84be036fda81e1c436b3"
    sha256 cellar: :any_skip_relocation, catalina:       "41f62e427083f128d1fe001349334911f6ba5b0b9d41f70fef8f09514cbc76ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b38ac79c0933ab487a4aa5a3dfc35440f4f27a1bb51b32d1bf0a8a0365d97f58"
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
