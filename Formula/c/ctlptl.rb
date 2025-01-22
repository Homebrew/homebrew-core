class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/refs/tags/v0.8.38.tar.gz"
  sha256 "c5516852cbea88dee9778e4f435614fad5fb95154faffda3cdc6d1632dd8f09b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4e0ec5e7898e25dec06817ec38201e1bfc1d94b03090dbc0d6b54a08746ced3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c68e8b188241cfb11517e0ffe253569d3d73a049b8e54780bf0bfb225cf64d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28e41e44cdcc544827ed57425d24bfcf9fe6b67cff515ae7794b51b2533a0d6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4509f00d6019d696c081f10ccb7fa227a3296b3151ee847af25481d0b4b112be"
    sha256 cellar: :any_skip_relocation, ventura:       "656bbca505019dd892bf9f3eee3cc367b582ce08c7b4d0fe7a09e25180131475"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf04ffbced6fb66258de4be62c8fcc2b4ebf19532c4936099ab4fc0e3f554e59"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ctlptl"

    generate_completions_from_executable(bin/"ctlptl", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_empty shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end
