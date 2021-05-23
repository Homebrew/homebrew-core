class Ehco < Formula
  desc "Network relay tool and a typo :)"
  homepage "https://github.com/Ehco1996/ehco"
  url "https://github.com/Ehco1996/ehco/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "326c468c3790ad01031e52ccb4efcfa5e331d2198fdb13137749c67e8eaacf38"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+){1,2})$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f5bb2716a01d4cede9dfdf1bdcf6f1170ac5ada0647cf55ac13d313e4af61489"
    sha256 cellar: :any_skip_relocation, big_sur:       "0735f491493dc56c2655dba4c1cdbe585860bd3e9cd934c00341cce9d836352a"
    sha256 cellar: :any_skip_relocation, catalina:      "1010c92ff010f913a575284a644707b835bf842dedf4850132ee161dd52ec0e1"
    sha256 cellar: :any_skip_relocation, mojave:        "de0558b7bc58fd084626cb1423c90a3fc74ab4f803b3db9142b8fa36cd713c9a"
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
    nc_pid = spawn "nc", "-l", "-p", nc_port.to_s
    sleep 1

    # run ehco server
    listen_port = free_port
    ehco_pid = spawn bin/"ehco", "-l", "localhost:#{listen_port}", "-r", "localhost:#{nc_port}", "-web_port", nil.to_s
    sleep 1

    system "nc", "-z", "localhost", listen_port.to_s
  ensure
    Process.kill("HUP", ehco_pid)
    Process.kill("HUP", nc_pid)
  end
end
