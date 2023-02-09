class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3011.tar.gz"
  sha256 "96ce2bff3d0e60fcedfe024f0667d216bc8d8c6f4a712f8a52e8fc3aa501d7b1"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8950863a5c7fcda90f778d9b1955cc49a2f71a8071c4d6a3dea0e363b0c00ce2"
    sha256 cellar: :any,                 arm64_monterey: "f884472e6ffe773cc5a37d50fedec80e82004f5f243fba3f9700b8cd89a05828"
    sha256 cellar: :any,                 arm64_big_sur:  "9d07f38fb76f82e17932b933be9060a8a9dcb685ef7643bd200b1250ce2db340"
    sha256 cellar: :any,                 ventura:        "13e94ff903bef46ff44e0bc4c326f8ddd86ea017351ab3506699ea2e1585471b"
    sha256 cellar: :any,                 monterey:       "208ce31b58e5557d238ba9d5de7fcfc966d43997f5eb7a61a7c05a5ef237b2ad"
    sha256 cellar: :any,                 big_sur:        "53478acfd8c0d900fb2c8601928e08cb0087bbbf85c672a2664540f8e5ce6479"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81c43c015c062bee181e04e231805d01aadc4ed225a5bfd4c4b3e2fa757c602d"
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
