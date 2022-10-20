class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2122.tar.gz"
  sha256 "2124628f0ef7a83e85184d7cb3d82d3744e8c86dab269e268922ec24337e535a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7af6fdb07aa38712b3f642db9761ad7cc2299b17c8ab485730cef66366074a4f"
    sha256 cellar: :any,                 arm64_big_sur:  "e2dea73b61efc20181ad899e8c3b2f2241ae5681a87b67103948a797d8d4af69"
    sha256 cellar: :any,                 monterey:       "190a5e7ffb8589fffe0382f077eb1ae5dbbd2972faafb80dfb4945eb8cf4a817"
    sha256 cellar: :any,                 big_sur:        "9fe7016cf817c57b4094a5d6640aeb5d4b1274a0ec59ed5df2ce6f4b5e2365ba"
    sha256 cellar: :any,                 catalina:       "f1fda18af80509d9a05e038b5ab12bf453507ed35255a27e7931493859158ada"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f4fbdf229971b0bacec19eb23129bc34111ebe68e0d2f5938b4f29a3d722abd"
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
