class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2732.tar.gz"
  sha256 "c70490e084f4ed0adc7a14d3c4bd179dbd9a3c5c62d87e94b6936e218a38560e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5a9cecaf346a926ddb703344d6ccf09928d1012a68a500e5c687d53b23ddb089"
    sha256 cellar: :any,                 arm64_monterey: "5fd143ec85710c34705d8b2f21405deceb5b379a8f00ff317a80735cb1f6dafc"
    sha256 cellar: :any,                 arm64_big_sur:  "15f40d22ceb6e040bfdc932b4d4fb8b1f4005f6fc5f8280d3bd349aafff24b40"
    sha256 cellar: :any,                 ventura:        "f4685c1cbef6507e435358b41be94996713f91af1cbb7548eb0a3c1985b048bc"
    sha256 cellar: :any,                 monterey:       "1ba06e92af545177466362d010f0f61323ec698a21b43822c1d987cea93e1637"
    sha256 cellar: :any,                 big_sur:        "712a9ce83baa4f59a276fb3548f73d9c70a0b980c26bc02e07db3fcac4295db1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8df0b7e7fb8b223f8bc4942d5a88ca14b35e370398d80ac46e9602732fe556d"
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

    begin
      sleep 10
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
