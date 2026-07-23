class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://arduino.github.io/arduino-cli/latest/"
  url "https://github.com/arduino/arduino-cli/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "262fbe874f62677d01eb15593144ca82bd6e7c2d0c00f82aa93949ab12924de6"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50f9660eee50b5fa13e9a3015372efbe037aa7f5a7cf6dc2e8cb40a04539f9d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4219fd4074b79195edf327b20702be7c7f45bf93d7bec8d4971b791c6d7ddd06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48f62e85e11bb3aad52c27a76d664cfb4c6f370f6e0c0acdaa316d6d700cd9c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a2a89caa7ff64f8cbe348d4a4448ae590128970ed9b8d1d9e83324819add1c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53a45f5e2afb48dec9dcc11f606a68a2f23a1df6e5a6b4e12c8a5e896ef396fe"
    sha256 cellar: :any,                 x86_64_linux:  "2f60d49fba0ef0aa348bcfc7ba1e050cc5777da0df2cc5ba169cd9341844344c"
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
