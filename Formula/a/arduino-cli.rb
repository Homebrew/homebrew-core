class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
      tag:      "v1.0.0",
      revision: "05c9852a0b8105c6c7b45303de87711db11a5f48"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f1dcfaa65219fb68dbdddc8060ee61cc33d72a6575beb080c90376d3514f118"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60b3334be78090a6b7f7a9cab4d716655c65becbbf7c9bd724fbc3fa602ea115"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15e2c28260063df50a76525fb050873e5b76d2a43a8ca67a35d023a05d25fece"
    sha256 cellar: :any_skip_relocation, sonoma:         "dce300d6ad1cd3951167fa5cb821bbcbf6427d841e23c7ceece0b13425573d94"
    sha256 cellar: :any_skip_relocation, ventura:        "b603198bfa7073d9f2c4ccf8a9e6169ff176c5f4e090fe7f140daa93f6ee1bbc"
    sha256 cellar: :any_skip_relocation, monterey:       "17ed0f297e1546116bda5cb50ef8b166ad4263ae4981b6145927ff32fa2fa1b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8aac4e417e3034cf6415d6fdc131c8fed5caf5a32cc1dd5c716f40cfa34507e3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/arduino/arduino-cli/version.versionString=#{version}
      -X github.com/arduino/arduino-cli/version.commit=#{Utils.git_head(length: 8)}
      -X github.com/arduino/arduino-cli/version.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

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
