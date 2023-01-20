class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2679.tar.gz"
  sha256 "ef8145f1ef212c7c12b390ebc69c7cb7f2dc86efdbb87477c2912242626d48b8"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0436362965d4e0484bac28401d6c5892c759a565d22a146ebc9ab639eee33c35"
    sha256 cellar: :any,                 arm64_monterey: "0a3a64d796559eda747a96be4c5cfc1219935ad4cf68d2928dc4a2277f26ce7b"
    sha256 cellar: :any,                 arm64_big_sur:  "a463a620b57028b30fccfc7e65744d54011147b6699b2f72d34a084788c60d38"
    sha256 cellar: :any,                 ventura:        "387f58c9557ce1ec4c6badd82a66775d77f8c40091d9fcab2cde8a8df601808b"
    sha256 cellar: :any,                 monterey:       "f7ccd04f7cd758518128528c12d4dc815af5f72b8d30f402a23d12178a464392"
    sha256 cellar: :any,                 big_sur:        "4ca7acf4a09eb30308cb054efa89fde853e1feef4ddd62f08d5cfc1d901cb9f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "230c4ca3bd8dc1e5cd39c9ff9cff8c836ac1c119504f4e7c0bb89dcd424f1dbe"
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
