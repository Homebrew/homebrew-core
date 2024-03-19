class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
      tag:      "v0.35.3",
      revision: "95cfd654fe0dd6b07e903d3132c0faceabfbe9e3"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "490da66935363b7a43d492bde7a10a734c5469eb8e6e0d710dca07be67ff1761"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e49003a5ff03579941a8ec60694177392bb8635357c0d36b31d28e99de98f1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba8af5d91337c4d2be5be0c3ee1cd0bf9e7a3efa6a0a523dcbf3ea89b744b552"
    sha256 cellar: :any_skip_relocation, sonoma:         "a03dda880772b74b038abb20d6b36db9b363c73b0e1c8a05646e3e2717f449fc"
    sha256 cellar: :any_skip_relocation, ventura:        "55caab9c9b0553dcac1803c21c222bd463bb626cef8bdf8c45cae8c1b141ea5b"
    sha256 cellar: :any_skip_relocation, monterey:       "2091b69e81aa97b36e587e86c50b65526ba4f45644e81a9634bc6833047c756e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcdfa3d4f57b7148a322078f3ed7cb1fa9dc0f0330fe29430d7bd4c6be5dfba5"
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
