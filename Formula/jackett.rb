class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2080.tar.gz"
  sha256 "08edacea68fd42c1564f4ce9ea97f8faa07703b562401484beb4293b90ed05c8"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "afb9c73a0b0848d9f66787d087b20184e970053de42e84443a90959e47c16e56"
    sha256 cellar: :any,                 arm64_big_sur:  "0cdf1e7f4b3407175d1e034495e0f3d8a5df13aacadc79019e8e28858ec8846a"
    sha256 cellar: :any,                 monterey:       "446eb73a842114231bcfde133acdb23cbfea179b3511e8216fd6d114d72bc63f"
    sha256 cellar: :any,                 big_sur:        "49dae3a2d7025c1a0a6de4ca75181818752dedcec7d23d0f9e2cbe9f33981a40"
    sha256 cellar: :any,                 catalina:       "f24909e3ecdf39404e27045eaf467bc5151fcde74ff07b3175ca7670b9383f1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89b666f711950ec056d16673f204a964d32e68279485c7a2003b25d50b8bb81a"
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
