class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.1759.tar.gz"
  sha256 "6b55f664aefabcb520b1ceea1c62747a16f0528af5f6a25bee0d91ab96f933b7"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "460af0c00c2d3423cb289093cefadd004e386afcb57420e53d953cacd35f8653"
    sha256 cellar: :any,                 arm64_big_sur:  "f6503e92b763add6cd3ddfe925c433f4e180848470d0e6d4d311269be09ee94a"
    sha256 cellar: :any,                 monterey:       "ad13cd6bf5e7c594b09d83a8c958d53ddb8b20b5c647f607ec29ecfeb90f0d14"
    sha256 cellar: :any,                 big_sur:        "1aaa74365e1f863b2208409198192332ede6213a4ecf3a1f4242885d001424b7"
    sha256 cellar: :any,                 catalina:       "a0622d6624613df574d57d324e5a719b9e2b0dd2fd7c97718a5cf61bf51665a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a136cb5374224ea2a268c81ceb3c0adb2d11754c62883450a18e9bf43f79be87"
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
