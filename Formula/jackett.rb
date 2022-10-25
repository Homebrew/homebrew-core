class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2163.tar.gz"
  sha256 "082ee9fefa1cf4b7a3eb14ba2c81046343be271037bcbd9a12d7c7baf74259c6"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0bd6a7151849ad88b9504219aa9cc30bb5b5058083673bf95cd399fa177d2abd"
    sha256 cellar: :any,                 arm64_big_sur:  "2eed9427ec42ef91ceedcd377c04b84dfc325fa934085a336f734e27c33865ab"
    sha256 cellar: :any,                 monterey:       "8c9ff99f79b21e55de55e8be18e00494fe003645d9b5afd35dc299af4a2424ab"
    sha256 cellar: :any,                 big_sur:        "6c0cdcb86634fa4e77b3bcf83d7a9eff96251e49888cc035f5b67f0c42916162"
    sha256 cellar: :any,                 catalina:       "b59cfa1191a8a10e223a9b14c84106ad9e4759d751727dcdaff8541ebb0f13cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b859c5759452be0038ee8eaef239cc79f75f1861948e5c2c87bdcebc2decb8c"
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
