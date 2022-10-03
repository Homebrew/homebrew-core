class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2063.tar.gz"
  sha256 "55d49e143c544c93c38636b35af029caffcd459cb5359e9aa0a48023a6cdc490"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e02397cb463c07583643a94f610c01abbb0ba90740234cbb8739ca0bed3c96dc"
    sha256 cellar: :any,                 arm64_big_sur:  "69369eb6816cc106c676a152cbc3336c97eb3e36b06008d94b30ee688bfc29d2"
    sha256 cellar: :any,                 monterey:       "77be6f31b7c771cd329ef861bb99f7ad5bd2b8400ebaa3747508c1c8a1bbbd64"
    sha256 cellar: :any,                 big_sur:        "3fe27907d46db48d8d05ef37225ad7a362bc3cbcc24e8436f87618511b235b3b"
    sha256 cellar: :any,                 catalina:       "e186c3cc788050d00bcfb5b91191cf63ab6013eadcffb6d2c08166bd7ece8bfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dc285e6d3954bc37ff0130f3d50730338a74afcb6898bce47a2e282b7f4a622"
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
