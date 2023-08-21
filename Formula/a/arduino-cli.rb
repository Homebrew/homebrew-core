class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
      tag:      "0.33.1",
      revision: "347bfeb0429dd7bce4216c44daff4680ba50f577"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8622880b2e903e6db60680592894e90d4be6f23b416fd686b7ef4cc0d307442"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3db81d6507f13b33aacb876ece1d01e4f60d5315e4a574c32a83e215f6fce28"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d28333f035653b26e5050f9bef20231132f0346373edbd180b17b7b7de0e7819"
    sha256 cellar: :any_skip_relocation, ventura:        "e3632eb5552aab2c611f9d979fe1bbcf27050193b1b7d1a191e4e9b9f99f9cd3"
    sha256 cellar: :any_skip_relocation, monterey:       "10143808a2f06f1fda03b974f10a3ef349cd3b01de7ab8d20ceedbf9d959a72b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b438fd2218467e739546bec9fbff7d66730d28e2a3fbbc43cf7fdb9c2881f080"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "222442212cb4fa38e94a82785f11a91aef69a7ca32cf267ef9d74ed68700e31b"
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
