class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
      tag:      "0.33.0",
      revision: "ca60d4b47be4a49cc972007296a31f5e1791e4b5"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90df240952d84d1e434fdb728fbac4f32623613b8a28cfa189620746b5ae8bba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecc257a4815d2e49b513537cb4d28d0657bf8bb0fb8f28089fd721fd5e541c6c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5fb1c8a4edd0080c0864f40e0a84dbfc3c8b1938c7fecf0aef53bd575b19425"
    sha256 cellar: :any_skip_relocation, ventura:        "934b66ce867f6f639acac91d6ff183201b4cbb212fe177f56af9b46ecd78c751"
    sha256 cellar: :any_skip_relocation, monterey:       "db4bc8115765ca94ad180e7e85517a587fb43344c6b2383c3f16889b8322552a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7294f9119259e6e24c97aa07aaaf3aeb94ae76fe76a2661874d093749e8d376"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a022caac295dc4da19a7499969e9a0ea37ce0852eaebd89b2091ea82312c01e"
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
