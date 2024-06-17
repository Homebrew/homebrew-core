class PowermanDockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/powerman/dockerize"
  url "https://github.com/powerman/dockerize/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "42fdc1b71231705dc7e272ded9dc5aeb3575e6ea6b9703e7a3d6cbc7b0b09147"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03db86807b1cf09a1582b0e66d3e980a9d32891f79de6802c3af50b67b90c383"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28d390ad28d7778972afe5b6638386650a0e6381bfbdca34e2248e1b0c486e0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "438ac307030eed2e49ebaaa9636fa71bfd0d3a510b96fa2c2795f964e89a3d38"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad5a15ea1493600daf3aa29a0377b856d72741a80ad9d17f741ebe4b30fef2bb"
    sha256 cellar: :any_skip_relocation, ventura:        "d4238b28deab36826cd328b5eb6134bc969e0a2fff249597afda9a8ef4321ac9"
    sha256 cellar: :any_skip_relocation, monterey:       "7975b98243d320f2054815329467b64c9a9d2c50eba3800de2a45bd0b806c05b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a54622fc7772d2cb89b888e122c57e8d1ff0ce392d6ffec673aaac8c50643fd1"
  end

  depends_on "go" => :build
  conflicts_with "dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(output: bin/"dockerize", ldflags: "-s -w -X main.ver=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system "#{bin}/dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
