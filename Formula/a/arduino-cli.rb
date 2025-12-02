class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://arduino.github.io/arduino-cli/latest/"
  url "https://github.com/arduino/arduino-cli/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "7977ef114eee32aec3eb2f371c6a5bbcf9b2238b1e923eb2d384c888ad1c1fe0"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "781f0ebbd54ea973f3d7c685c978bbd69735de45b6fce860e14e6c3abf9ca124"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3aedb3a445445c4cb9580cfc0013fae74f26b35e49eae7d8a6869ab0d7a3385"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b3697ee5b068123f44b35fbe307aedbac3db13ea5cbc4a8181e6da03e949239"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b1c2817ebb4d5156f2f60f7633e5e942804af6936d256886ee380aa52a5305a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "55f3c059903e61aaf929d9e28c4493f4602d253eb3dee2db4f296c351f8d7349"
    sha256 cellar: :any_skip_relocation, ventura:       "83c5c94009164256b3d69af9244f409721b825852211b935a02b3cd941fae9b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a94b9756b8f7d8674e97134c47d5e36d7c561ded406f4ea109d1d1e1bd6147a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b871670ddad2f671f411a7fe9117a19e74f0ec831300207575813830964cd41f"
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
