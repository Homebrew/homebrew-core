class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.4119.tar.gz"
  sha256 "0ffa41ba937b77b19353ab8f04fbe409cad84fd49afe0ed64e03033eb3c27a83"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b44c1856d23943c4e4ad0b40a9ea88be0fe924031dbeb11739db950e4feff7fe"
    sha256 cellar: :any,                 arm64_monterey: "60315afa56c0ce8463e8277af3df2c460d4bd4f028ad192d4df3f538807f4fa7"
    sha256 cellar: :any,                 arm64_big_sur:  "385929265616f858431ed1f75cac82cea69ef0b6b1e231117df8c69e4cf9ad49"
    sha256 cellar: :any,                 ventura:        "e8d8959b8d1b1b42047990ac6ddd680c8b77051fde2a903e382018bb941368bb"
    sha256 cellar: :any,                 monterey:       "4c2a208bed811e616f395b7630b502e2c1966d1b32c64dfcc78e861d4ccfb9e7"
    sha256 cellar: :any,                 big_sur:        "c3ee9f86351c0577a38a0ecb199795dfed617757f8c140dc967b9cd57057214e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "357c4e9c4fd5b2fadbd66da9dea6fcc36647b27376d14793060dbf20e0fda8b5"
  end

  depends_on "dotnet@6"

  def install
    dotnet = Formula["dotnet@6"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
    ]
    if build.stable?
      args += %W[
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "src/Jackett.Server", *args

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin/"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var/"log/jackett.log"
    error_log_path var/"log/jackett.log"
  end

  test do
    assert_match(/^Jackett v#{Regexp.escape(version)}$/, shell_output("#{bin}/jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec "#{bin}/jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 10
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
