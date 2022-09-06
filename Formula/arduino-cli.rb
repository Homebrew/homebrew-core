class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
      tag:      "0.27.1",
      revision: "a900cfb2e7e58a9ed7e06be607c0f9878a17b15d"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72d2854d2d8bbbc37f217d933780be1b85e5405431cb712f57a5b21c3208a48f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "224e8ab3f66fb00f01d1dcb5e3f835ccdf3d18b436e7e8081096b3bb094f6c54"
    sha256 cellar: :any_skip_relocation, monterey:       "cb38e654bde959c99db131283e83f984b3fa418fa89d33efe8e1c25b08f496d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f81e9b424e8aa666127711e17a3c32262b53eccc574d5d0fed7b62eb8b87413"
    sha256 cellar: :any_skip_relocation, catalina:       "6faf2c935fa86f61d025aed7a042a224c03204a3866b54a2bb872fafa7b68b04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c21d6f93cff1fe8b512f1c7581f4cab6cabb7317908efabae3a4a8f8ccf79d82"
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
