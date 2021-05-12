class Ehco < Formula
  desc "Network relay tool and a typo :)"
  homepage "https://github.com/Ehco1996/ehco"
  url "https://github.com/Ehco1996/ehco/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "326c468c3790ad01031e52ccb4efcfa5e331d2198fdb13137749c67e8eaacf38"
  license "GPL-3.0-only"

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
