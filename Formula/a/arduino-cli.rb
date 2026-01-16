class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://arduino.github.io/arduino-cli/latest/"
  url "https://github.com/arduino/arduino-cli/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "142d48462387c0bcd900e7969892b974d26bcfa9e42674bf9e9c4da2919ca857"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97251e43754d7351f747e7d250e1cd9dacd1043e7c7c35744f319171e13dcdbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "090e63207aa44fede0cb59bf11573edf95c6703d57e2461321192458cb39623c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ae332bf72282d36a08a7d615840efb7b0ab7c3361f0893a186b0d66b9f6371a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a73a2453bcd4a89ea7cf2a1d6b11143e63cb9186a37d773e255fbfd9c04ee31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a8d7d1c8d40e7970f6412415410991ffdded4869035451f043d121eb55bf542"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "716f027a92718c5c527fc4cd4250419081a65df1946e39afd7294c1726fff953"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/arduino/arduino-cli/internal/version.versionString=#{version}
      -X github.com/arduino/arduino-cli/internal/version.commit=#{tap.user}
      -X github.com/arduino/arduino-cli/internal/version.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"arduino-cli", shell_parameter_format: :cobra)
  end

  test do
    system bin/"arduino-cli", "sketch", "new", "test_sketch"
    assert_path_exists testpath/"test_sketch/test_sketch.ino"

    assert_match version.to_s, shell_output("#{bin}/arduino-cli version")
  end
end
