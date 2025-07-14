class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://arduino.github.io/arduino-cli/latest/"
  url "https://github.com/arduino/arduino-cli/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "c999f61e23c253d567f49c20ac4dc5d4e3187515dc7e1a42ac0482cb7124730a"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a608c9576803a752c6fad9769438ac81746dc5c7ebb57e374f90e85ee324ff7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7118a669115eff71a26d4e1b7606e3675aa20e08341005e161f468a1c8d118a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c9fd8b3d73e37dc19802dac51184600a87e076765e3d992a670c4ac6bd6c1e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "ace58a00634d583f8c3f4935325920681fbcf046bd0f1e2da3983d66aa33a666"
    sha256 cellar: :any_skip_relocation, ventura:       "6f85fe13dbaa8d27f391c537f8db32b037788e4ba03cd64118898f36355406fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d364c4c804b7798d8540289ac5872b157c958762e1feca8f5d83b04c2cba4681"
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
