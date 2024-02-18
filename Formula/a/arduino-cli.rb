class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
      tag:      "v0.35.2",
      revision: "01de174c7e3c08b9c4db121e77a5f7947f968097"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd96686b06fdc5276fbf8889cf3c00ef796dd660414be3290c4bf8ff56724df5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae00657ae692751a769f3b8325a6c4866165d9afb755a5ef1800ef8ff1803d0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19e190bdbff6e702b2460b507699767d5c3ccb9279021d3c9d0856d44c1b6597"
    sha256 cellar: :any_skip_relocation, sonoma:         "4dea11eb80eca9d1a64c34ea602c5d916003ba6064f6b978964905ed9a8cb332"
    sha256 cellar: :any_skip_relocation, ventura:        "50488a580ff40f720eaaefeb3f3b2a2d935d2da9fc32b9bcbfc7b080e6fa3b81"
    sha256 cellar: :any_skip_relocation, monterey:       "57e82687259c26ad17138b0913185eb35795738db0000e6b047f7967b6c85461"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a0f15e2b8f73ff147cc39ba69e796208eb2567b862494b36580756a0b4ffd83"
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
