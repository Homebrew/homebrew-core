class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
      tag:      "0.22.0",
      revision: "65f662a782780f9e410a3c327b213e55163f4de9"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3dec1f3c459fdd69e66bf0d126014843433530c5e4b3691f2afc96e36517c6b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb2112a778a51b0694bce7126b2087d3b7423d43e7bc9a17ca091e540b63e874"
    sha256 cellar: :any_skip_relocation, monterey:       "e311e10467a48c5a5f789db7ed623feea9a057e8788a2887f96c153bd4da39e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "0690d00cbf4d1998808583f366ae07b356242dafc29fbd76ebb98d6b77c22413"
    sha256 cellar: :any_skip_relocation, catalina:       "aca5fc83b3ce352bd328c8d8a89d6db38206faa27a3ebaa79f7eec46689741bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff3d5399e3f58c037f726cdadbd6413e5d0171c2e107d2b878cc3a2c28691e3d"
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
