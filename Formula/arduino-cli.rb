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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bcc50cdd22e2597174fd83fd7b409680f426074f0535b96d3f52c7787a31f94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5aa6eedb692eaa54e9e786af32eea78cd5989ca4e59e3cf499ae4697b7518b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7cc0936a702963ac99e131f967cd161122517b549259edab23274a2fa699a45f"
    sha256 cellar: :any_skip_relocation, ventura:        "9ca09d782af2788ef0518e3482655dd2e97daf510411c2ec859bd640f11c23e3"
    sha256 cellar: :any_skip_relocation, monterey:       "8bdbd9e026ae143bb3e76866daf6ff9014246e0c909611a17e602c3ce2bf0483"
    sha256 cellar: :any_skip_relocation, big_sur:        "9651f74409036ca8ae29a80b102aaf3cd2950c0061a887a17ff1c3b0f7e61783"
    sha256 cellar: :any_skip_relocation, catalina:       "e3975ad2f65997a43ce17adcf9f6f4ce548369893851e8604a21c57eb1a130c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4262d86f48752b81f86f3c75bef24a1ed2381a3b56b1402d643119ac4e1d9733"
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
