class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
      tag:      "0.28.0",
      revision: "06fb1909437145f43deabb9cc962baf38bfa12eb"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a15b34f012e389e4c7a9f19361994ca9b7a7a8a53b0de8423056bd1d443df7dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19cd18e42d133765c6c063841d0a1e49fce6efe1752bd45e77ed7312593b8f1d"
    sha256 cellar: :any_skip_relocation, monterey:       "1d12c1f7a21bfcd6068b89a6ef260af6f6212a13e9e6caa514b5b13b380697c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "11b70276994f04ce086d8237fbf15807aca91f8ae75c3150e8a9e6e7dbbe5e40"
    sha256 cellar: :any_skip_relocation, catalina:       "86acba84493ff259f808ed7d896f466dd2a51d58c9ddef6b9dc15f8ae2ea4482"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01ccd8a332aa5e9ef7a8b209bc57a6b4ac7abcdfb70042258edd716577f574ad"
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
