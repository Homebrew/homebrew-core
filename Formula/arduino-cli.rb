class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
      tag:      "0.29.0",
      revision: "76251df9241a7e09108bbc681d7455a024bccd13"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65341e1dc50c6bc8342295f5eb189b9ca4d58d15e0a40fc20853631bd37ff9d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa68f85cf87610e99629b2af369a60dcbcb0f8d0a1c2d242f127bc9feb58063c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "213a79311164d42ecccf7db7790cf0427117510d5752f661a54d9b2335a86d75"
    sha256 cellar: :any_skip_relocation, monterey:       "cfde519741ae2cf221065a6b720b29b03c4a579e3561fddf5bbb0d54c76ae9e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "feda5797143fd8a67146834161b24c70666507072736b07fd766d82c2559962d"
    sha256 cellar: :any_skip_relocation, catalina:       "ac2029f56c8002b4a2c58d8f38404866c652604a87561b0f1936f4b70b913895"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ec60d352a7f777475eee27b5d6fa8fc54b8267f9c92ea5cc21be7dd0a136491"
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
