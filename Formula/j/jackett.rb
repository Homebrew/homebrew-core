class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.2199.tar.gz"
  sha256 "f21520b2ef912dca574c4b1dc749e2974f3c77a1cd61720cf7771429fd14e7c8"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "eab77a6abac878278523193cf03c910f2b6b176b791ae621f83ab89267fd81b9"
    sha256 cellar: :any,                 arm64_monterey: "4e4cce46df98c9d140fa7316e73fcc0e7b6192f4dace2e35c4a7efb42ee30a99"
    sha256 cellar: :any,                 ventura:        "adffc9aaab7d9c1fbfe475704b278a4758f89ff52da2e64ed493f5fd9501805c"
    sha256 cellar: :any,                 monterey:       "b988a9e7cb8426b57c5a459e3b016c65184b2e44d57950ce3604e772408a7670"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23d7c82fee4fb2915623d8aa3946ef8a7286d1355fc1ecf8f10b993411a2730a"
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
