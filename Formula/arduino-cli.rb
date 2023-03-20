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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e1c20b673fbc1a1a5b25a2ab60d9219df289f29a10954121f504d2efa67895d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9951a5c0990b6f1e6c6ce9be982b5597fac30c5404e676739f4717efb7e001a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb265c92a8d2e64aca7b8b8b9edb2f3e45af88b74b3934a8c0299b59db247135"
    sha256 cellar: :any_skip_relocation, ventura:        "3408b5b23bbb18275ac672a0d463d32d32a27736ae2982ef45c98bceed07236f"
    sha256 cellar: :any_skip_relocation, monterey:       "94c4b7d8d4e34228978806c156b8c3a205135cb0ca236ba3b20ec024a74982e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc322c8d740eb79f1e5d543406ff8126b10b7277b44a6abd886ae39e500e4f27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44eea103b891e5186353d9c7dc269fd6aefe2e6abf8f86f6d2d6e7e1739b666d"
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
