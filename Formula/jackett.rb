class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.290.tar.gz"
  sha256 "2dd96bec14208b1d7472a4a0e3d7a11fea1a87986c10caf4c66c8bf91b35aa4e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f33c35d5d33df9d8ac8a58e3a1356bb61fe75c02ba258b632ba552aaff98ed4f"
    sha256 cellar: :any,                 arm64_monterey: "6ea8d06f3b766211ed380340219df7322b9ba2102fe48e83cc7b4717c8b1f251"
    sha256 cellar: :any,                 arm64_big_sur:  "5e29fb3fc9715d656f1bb9fcd747d0f021954bff7f8105a3c155b5912fe3e7fe"
    sha256 cellar: :any,                 ventura:        "5f186c0f1f72d27dd342b7b42856326c816ec29ef715b761ba309c619a37f242"
    sha256 cellar: :any,                 monterey:       "62cd870145dd61879c075708b8bdec440921b2a286e9ac38de307c600ea830bb"
    sha256 cellar: :any,                 big_sur:        "a079a22e177d41ee2aa9a7ffe19e0edb5da86ebf3db27c786e0f6582225d7f67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19440fcafd22e993abac88fe5136ba4e6a72887c5e7c531f3fa98dd13ae3e8b7"
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
