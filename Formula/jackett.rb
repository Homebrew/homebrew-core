class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.1196.tar.gz"
  sha256 "448d8ef7c62a9ffce2401531d0d1384dc5f2292dffd0377e59b628c583ec764a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bdc663b94e20d1d8d4d02990fbd1219ec49fba2a0f187c19afecde15c6e2fb6f"
    sha256 cellar: :any,                 arm64_big_sur:  "7040ec729572e245da209edb99a2f1d483bc8121539ff51335874532011f6153"
    sha256 cellar: :any,                 monterey:       "2d0966b5a3fff5e851a7eb999c6ee9773a3d63b8b30bda1235d05ba043313b34"
    sha256 cellar: :any,                 big_sur:        "01725f1bc143576064e3361b097f648fe3737468a15dec104c9f378d68eb226b"
    sha256 cellar: :any,                 catalina:       "4869a859e5b671acc5f1f3dc80e9f8b3d2daa5820a20b9d194b1a1a28bb5b96c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2288c7e87789f620c938551d575ad1c6c184e1704bdd56151153c6a15fa81b09"
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
