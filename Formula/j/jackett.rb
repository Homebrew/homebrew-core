class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.2163.tar.gz"
  sha256 "1f6a44a30fef1cc9a9c637c803fc5dc03d0bce68ba034d85ed50ef373d0a2c58"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ff748593faba2dff788b3bf2d201a5ddfcd633359ecdb3196fc6cb5e4816ed14"
    sha256 cellar: :any,                 arm64_monterey: "405df9f4b19aa83ec8fe6f496f730933af7dca05941d00e5e09a5eeaf0e0553b"
    sha256 cellar: :any,                 ventura:        "7b60ba7391d741ae9d2c0955f4eceda960a9b747e1e51c64b2a6f6e8e63a921e"
    sha256 cellar: :any,                 monterey:       "44355dcae0f1c2ed0b4b51f706cf062eb2ae55cdd3443aa3226071d6a80873dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6a85c285bc7169e8cdabc0e2419fd870548a22498a1c2fe46b4e979110ba3ad"
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
