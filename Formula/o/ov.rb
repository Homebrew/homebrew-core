class Ov < Formula
  desc "Feature-rich terminal-based text viewer"
  homepage "https://noborus.github.io/ov/"
  url "https://github.com/noborus/ov/archive/refs/tags/v0.54.0.tar.gz"
  sha256 "78248f48adb5deb6ca2e560b57583f0ae66ac5e71704b7dc0b35d2378e0df5ac"
  license "MIT"
  head "https://github.com/noborus/ov.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b088b9716ec07662400f568b3c12603ff518e471be64594d8f18354a48a8115"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c9d75a90397c5dac2a1959cf46c5bda96556700be9df5a232c519abc7749c0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66e164cfee2763f231e650df2496be029eb6a8bee6d05926ddedb29c7baa8cb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e53f8d4997f05c4fe5f4ab0dc297bc1e827f41addd5006c012320ac5b2b8e5c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f6f3f3188f2cee378e202096bd586ab696c6dff463a9821dcdd5410cffd9552"
    sha256 cellar: :any,                 x86_64_linux:  "2566302d126f08ac5ce167e677cebb2baf9010f2c736281cf33b3bbfa475b8dc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ov", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ov --version")

    (testpath/"test.txt").write("Hello, world!")
    assert_match "Hello, world!", shell_output("#{bin}/ov test.txt")
  end
end
