class Fire < Formula
  desc "Easy to remember wrapper around kill to terminate process by name or port"
  homepage "https://github.com/evpgh/fire"
  url "https://github.com/evpgh/fire/files/11289996/fire-1.0.0.tar.gz"
  sha256 "d83a1a856f792f6564e50c62bfcd61fa3dbb4a05ec3e2bb202ae5d2aae50c70e"

  def install
    bin.install "fire.sh" => "fire"
  end

  test do
    output = shell_output("#{bin}/fire random")
    assert_match "No process found with name random 🧯", output

    fork do
      exec "sleep 300"
    end
    sleep 1
    output = shell_output("#{bin}/fire sleep")
    sleep 1
    assert_includes output, "The process is no more."

    fork do
      require "socket"
      server = TCPServer.new("localhost", 0)
      port = server.addr[1]
      File.write("test.txt", "port=#{port}")
      exec "sleep 1000"
    end
    sleep 1
    port = File.read("test.txt").match(/port=(\d+)/)[1]
    output = shell_output("#{bin}/fire #{port}")
    sleep 1
    assert_match "No process found listening on port #{port} 🧯\n\n", output
  end
end
