class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.1151.tar.gz"
  sha256 "ee5ae7ab6bde5cfcd3fb7d649d89abb952ace08e129572dcbb39697dda0f6b05"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "916a57c34017c429fa3f16aeaf640a0932897ad74a41171b0e1281c61745723c"
    sha256 cellar: :any,                 arm64_big_sur:  "3e778d809271d4f254d88f9269135eb5725850ce954ba523d781ea1b2c560427"
    sha256 cellar: :any,                 monterey:       "3cc2a5bca88bb687ae6cf4a7b4951bd7b4426514612b23835765fd7742fa6186"
    sha256 cellar: :any,                 big_sur:        "67fdb6b75c3abe5066c1f47b92f046d303187032587dae3ab7549699b15ad088"
    sha256 cellar: :any,                 catalina:       "4a942a767031212bfb475f18f703f2ae73db93633488f7a118f336fe1481f84f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd61339f668e64642b09f7b21b0b704be213de1e522e8285215f41d1f9cf97c7"
  end

  depends_on "dotnet"

  def install
    cd "src" do
      os = OS.mac? ? "osx" : OS.kernel_name.downcase
      arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

      args = %W[
        --configuration Release
        --framework net#{Formula["dotnet"].version.major_minor}
        --output #{libexec}
        --runtime #{os}-#{arch}
        --no-self-contained
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]

      system "dotnet", "publish", "Jackett.Server", *args
    end

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{Formula["dotnet"].opt_libexec}}"
  end

  service do
    run opt_bin/"jackett"
    keep_alive true
    working_dir libexec
    log_path var/"log/jackett.log"
    error_log_path var/"log/jackett.log"
  end

  test do
    assert_match(/^Jackett v#{Regexp.escape(version)}$/, shell_output("#{bin}/jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec "#{bin}/jackett", "-d", testpath, "-p", port.to_s
    end
    sleep 10

    begin
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
