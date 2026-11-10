class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://arduino.github.io/arduino-cli/latest/"
  url "https://github.com/arduino/arduino-cli/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "d513a9fbac5a30e63dde600d3e44e3376d68a7e2c11e9c692c1afa9b479479b4"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7414060afe50509dffdd50f3f83f8020983fa335170a2e8f740cadbc8f43b551"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1a39ed700252fd746ae57aacc6ebbd51abf4f2493483f169e5995dc50425ccb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9d344cca1ac9b903b1a6e7ebb0d5dc0b0eb11f8fb4c39dc0149d9dbe6b12136c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cfeda7b7926fa21ccca6b27c4937944db876ed6023e36ea504eb84ceb0221c98"
    sha256 cellar: :any,                 x86_64_linux:      "856e2730f80a3d04790ff9b98c8b7d4d5994924c310600f86039223dbcad8b28"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
