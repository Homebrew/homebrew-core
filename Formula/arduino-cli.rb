class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
      tag:      "0.19.3",
      revision: "12f1afc2c1dee08d988974fe8f80e849f7ce4681"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1083a40929220443dd9b1815aca90084d0c318a98a5ff6a30ae4b02a5ed4075"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7c99dfd8d41749d82e01d14bbff6150123743937ac2ad14113f54414c31e225"
    sha256 cellar: :any_skip_relocation, monterey:       "effc2d51dbea151ed60c7b3bf15a8a551d099201bae62acedaf6703aa9a16b2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "90d2f9b3d059543a0f111f702f50e2766071c1070eb165128d96b3d2190ac225"
    sha256 cellar: :any_skip_relocation, catalina:       "a0610fecd4b7ad1d08cb3e4086f995102f4440ff3f76d157305ab74c120524bc"
    sha256 cellar: :any_skip_relocation, mojave:         "5e22540f58c5261d1963e0f4550f08696b016b3ac26bb1edf3a9e6753794b35f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9467a330e3df2f50d077c19af97e6a9cfa2e9a4546494f281c306a93450ca672"
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
