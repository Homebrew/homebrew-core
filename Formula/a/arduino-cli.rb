class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://arduino.github.io/arduino-cli/latest/"
  url "https://github.com/arduino/arduino-cli/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "f576e40873037e39cdd1a8297b34aa8305b53e2268307944765778a925dba0f1"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65c18aeb457e1a171941dac4d882f57467dd1fe886bc02e77e19bf91c793b2b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "443e3135d25adec258831b6022fb88ae84cf6e00693c8eb57a9494311096effa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fde8ba1329da35e65f4a2f9644a9379bc34cbf3575c5d253bdfd285810e5f783"
    sha256 cellar: :any_skip_relocation, sonoma:        "e474d3c5083fde1f94a3b784dc82ed48f43098c3f03414d81aa1f9a73aeec27e"
    sha256 cellar: :any_skip_relocation, ventura:       "fefb8aa5d54ba49d51eb1596796ea112f074ca4e412d287043031a222b536aaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fba9b977f224e3a63dd8f946c6fd75141e178a4d285bf62b8144d91282ae571"
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

    generate_completions_from_executable(bin/"arduino-cli", "completion")
  end

  test do
    system bin/"arduino-cli", "sketch", "new", "test_sketch"
    assert_path_exists testpath/"test_sketch/test_sketch.ino"

    assert_match version.to_s, shell_output("#{bin}/arduino-cli version")
  end
end
