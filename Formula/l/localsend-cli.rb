class LocalsendCli < Formula
  desc "Terminal client for sending files between nearby devices"
  homepage "https://localsend.org"
  url "https://github.com/localsend/localsend/archive/refs/tags/v1.18.2.tar.gz"
  sha256 "4425dfcf2e016d6540ea44941deb4ba6568201cc47d7f08753606e6e4b2769cd"
  license "Apache-2.0"

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "Not a file: missing.txt", shell_output("#{bin}/localsend-cli --file missing.txt 2>&1", 1)

    require "pty"
    require "socket"

    port = free_port
    config_home = testpath/"config"
    reader, writer, pid = PTY.spawn({ "XDG_CONFIG_HOME" => config_home.to_s },
                                    bin/"localsend-cli", "--alias", "Homebrew Test", "--port", port.to_s)

    deadline = Time.now + 30
    loop do
      break if begin
        Socket.tcp("127.0.0.1", port, connect_timeout: 1).close
        true
      rescue Errno::ECONNREFUSED
        false
      end

      raise "LocalSend CLI did not start its server" if Time.now > deadline

      sleep 0.2
    end

    assert_path_exists config_home/"localsend-cli/config.toml"
  ensure
    Process.kill("TERM", pid) if pid
    Process.wait(pid) if pid
    reader&.close
    writer&.close
  end
end
