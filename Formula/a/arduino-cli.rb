class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://arduino.github.io/arduino-cli/latest/"
  url "https://github.com/arduino/arduino-cli/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "5a07d1848a5e2e6fbf49aef0ba6794aa865c8b31d74ffed979eb382810725bdd"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3fb3772bda59c80c8df9667f9833cdb22ddaf8364afdf02923e7a28c61d840a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b6a3d27acd32f5d1b92779d26edd0390013e26e8b79806404234e32c3b55abe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d7745e133d19aff9b40b05e144ee91718e1c8790a0914bfefccffba669556b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a64e1f20e2b364c10d5a9050f065f54f0e8a9fb8720517dc27fc429797235e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a9103d4b4426cd3d211019b6c784e70a3c059157d0a078f37239fb536352c74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e66db01f8d9a8b69b0f1bf669c1b81ba151eaa99604f2103d2a7eeea4db0d6a1"
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
