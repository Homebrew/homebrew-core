class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
      tag:      "0.32.2",
      revision: "2661f5d9a68c028df370cd56b4ae7f2a4b651c4c"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1b9f69f1a7e38811226ead9fba60c1fd615157a6500f113ae000d23f72135a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54269815f85b046dd3a99c0e43ca9d9a557b41b2f55995aa7b108609524b647a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f6f7d158ab5c16898e8bbfd294e001cdddf58ef6f0c704c4018d5e096784ee6"
    sha256 cellar: :any_skip_relocation, ventura:        "1aec3bf2bed6a68707569aafb6fe046a6844eb35c5aeec217ec198a13eab8870"
    sha256 cellar: :any_skip_relocation, monterey:       "39ba657ac972634dc12e0917ba95de798609926224d90fc68937cb202ad736e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9208f6145862d79a9719d2dddc23f4da99063aee23b061ce0ead66de3f4e554"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d0c4f4f1d3ad70d851b474df823f6af9a277dad33884f4900fe7128780f5e4d"
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

    generate_completions_from_executable(bin/"arduino-cli", "completion")
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
