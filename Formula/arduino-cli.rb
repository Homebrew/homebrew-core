class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
      tag:      "0.31.0",
      revision: "940c94573b1f446c2aa7f2011f123550e068d9e4"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "755d227f5645f79bd9e86227c0f8652ab126b07d9aae1eb3993faecb5075dd7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e5492ed399c18660ef02d5978c2b9587466f1c34d72f9907b06d2fac7703737"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b14909675ef39de72fc41bbd036f8a46b0b06a10610863e760ac6ba895bec7e"
    sha256 cellar: :any_skip_relocation, ventura:        "2fced1203052531f6a819413b5a21cbfd356292b187fed9be8d1036165d2e68a"
    sha256 cellar: :any_skip_relocation, monterey:       "52e1caf9a86df8659c474c705c058de703ec9bcf7dd0f264b4cad34e347ac8c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "9559149ad7811e62246fa75892fec6be363fbd320c6fd928eeeaf8bb691373ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30e58bd343f56db58a7f0143261db3a9567e14a72cccfcea86a90c799962c16d"
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
