class LocalsendCli < Formula
  desc "Terminal client for sending files between nearby devices"
  homepage "https://localsend.org"
  url "https://github.com/localsend/localsend/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "2906534b592685b98692d934805dbedd8158d62eec9931874250a010bfffa79b"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "ba8ab1128f1d980a0456bca3972b8bd632a6b5421e35bf4a424383d98940800c"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9805a4310ff15c10902cb663e8ed09fc109277a11a8898c34d32ca08ca00e476"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1ddf9e4dac1d9248ad0973b796d2ab34949bf8cb8442729814efb562b86b0041"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "197b8893cb8943bb4e435eb6e21f3dee39c2467e9bbf74b787dd17aad6237575"
    sha256 cellar: :any,                 arm64_linux:       "db78180674aab7db838653f4ff24772239e5d8bf326b225e00dca19325fb7c63"
    sha256 cellar: :any,                 x86_64_linux:      "f7b178539ad086fffb4ef1111848801dbd1bec32c0ee8490df646b32f77249d4"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "localsend-cli #{version}", shell_output("#{bin}/localsend-cli --version")
    assert_match "Not a file or directory: missing.txt",
                 shell_output("#{bin}/localsend-cli send missing.txt 2>&1", 1)

    require "pty"
    require "socket"

    port = free_port
    config_home = testpath/"config"
    PTY.spawn({ "XDG_CONFIG_HOME" => config_home.to_s },
              bin/"localsend-cli", "--alias", "Homebrew Test", "--port", port.to_s) do |reader, writer, pid|
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

      identity = config_home/"localsend-cli/identity.pem"
      response = shell_output("curl --fail --silent --show-error --insecure --noproxy 127.0.0.1 --max-time 5 " \
                              "--cert #{identity} --key #{identity} " \
                              "https://127.0.0.1:#{port}/api/localsend/v2/info")
      assert_equal "Homebrew Test", JSON.parse(response).fetch("alias")
      assert_path_exists config_home/"localsend-cli/config.toml"
    ensure
      Process.kill("TERM", pid)
      reader.close
      writer.close
      Process.wait(pid)
    end
  end
end
