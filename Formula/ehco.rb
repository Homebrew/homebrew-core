class Ehco < Formula
  desc "Network relay tool and a typo :)"
  homepage "https://github.com/Ehco1996/ehco"
  url "https://github.com/Ehco1996/ehco/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "d6384cdb31befcf9a198dd1be6c0073e9fabb6823f2f92df63bb50fb14ec6ff1"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+){1,2})$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58b3a1bcdc7f9aadc08965c587b3d6fa877075d62b639c90f94a0016a94ed657"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc4c8b91493e822d5068ae6d02068f5c5e7790d8d1b776b1fb1bea9a077c4fbb"
    sha256 cellar: :any_skip_relocation, monterey:       "1cedf54dd057b2341cd5d553427dc7109ef6b07fd028d5739c6ddde38d8f999a"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbfc3978b9a69b1f381ad64231606dfaeef27f8d3d9e9b433ecc879828ea0280"
    sha256 cellar: :any_skip_relocation, catalina:       "039a8b48a139e971b5c8587ed75fb4f44fd4b117f824157e2cc50f85ac08ef33"
    sha256 cellar: :any_skip_relocation, mojave:         "a790f96ce6704e4cc4d0fcc3e962ae8d6d79711d8b72bb2eb788d37db9b73b8b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmd/ehco/main.go"
  end

  test do
    version_info = shell_output("#{bin}/ehco -v")
    assert_match "ehco version #{version}", version_info

    # run nc server
    nc_port = free_port
    nc_pid = spawn "nc", "-l", nc_port.to_s
    sleep 1

    # run ehco server
    listen_port = free_port
    ehco_pid = spawn bin/"ehco", "-l", "localhost:#{listen_port}", "-r", "localhost:#{nc_port}"
    sleep 1

    system "nc", "-z", "localhost", listen_port.to_s
  ensure
    Process.kill("HUP", ehco_pid)
    Process.kill("HUP", nc_pid)
  end
end
