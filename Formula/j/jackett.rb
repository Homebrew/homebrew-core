class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1973.tar.gz"
  sha256 "3a59fb55f3246a06768e885d2f82881105df688b6c53a5c27062bc38cb30ec47"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1ebaa56b197dee51ffc21c90a158ec397a76337085fba43b1a532feb3cbf99c9"
    sha256 cellar: :any,                 arm64_monterey: "68732db076a7c60b5a944cd50d896e02a48c16c2e254a996250608de91f78ed4"
    sha256 cellar: :any,                 ventura:        "e729032e197c790c7f5779da2be72eef7e58318ee259e4ece6b199c797e56a8d"
    sha256 cellar: :any,                 monterey:       "a70f721268aa51934c04326f51f7c96a046d93540dcd575d7b5506f7d34b5a6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6d8b70a7465bc29647ab3c61aa6d0b88ed7c865db7d2d82dade0b05fffdc09a"
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
