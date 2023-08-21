class Phoneinfoga < Formula
  desc "Information gathering framework for phone numbers"
  homepage "https://sundowndev.github.io/phoneinfoga/"
  url "https://github.com/sundowndev/phoneinfoga/archive/v2.10.8.tar.gz"
  sha256 "7aef72755c5bea9ba80b73dcacc7757d3933ffb135d7a3f8e8ee5786a764e852"
  license "GPL-3.0-only"
  head "https://github.com/sundowndev/phoneinfoga.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "adda96680af077cc100e72b30546128ca60a5af0d5bd9004403fd1ce44b842be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ea74cb7e516aaae8d68d531116dd796b32f1c9ce580810efa263fbc65df84d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d89f826b851aa2079145fe62d5e6fb95851135e4427a06110657bd264f74470"
    sha256 cellar: :any_skip_relocation, ventura:        "a2da9a20587e92301cda1b890bc0e5a7a8369a9270c8e12339fe4c2d96f91307"
    sha256 cellar: :any_skip_relocation, monterey:       "f7e2c5cf3e76ce4cc78a17524ee2c27fd9b83b3a87908658596f9aab21a958b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "d01314dc129020adb39e2c04f94356277b88400d7d5638b7ff1936df89b071eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dc024421a4b9b09dc3acaeb6996757bb8e1feb27941cd3b0391dc3f8b3da79c"
  end

  depends_on "go" => :build
  depends_on "yarn" => :build
  depends_on "node"

  def install
    cd "web/client" do
      system "yarn", "install", "--immutable"
      system "yarn", "build"
    end

    ldflags = %W[
      -s -w
      -X github.com/sundowndev/phoneinfoga/v2/build.Version=v#{version}
      -X github.com/sundowndev/phoneinfoga/v2/build.Commit=brew
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match "PhoneInfoga v#{version}-brew", shell_output("#{bin}/phoneinfoga version")
    system "#{bin}/phoneinfoga", "scanners"
    assert_match "given phone number is not valid", shell_output("#{bin}/phoneinfoga scan -n foobar 2>&1", 1)
  end
end
