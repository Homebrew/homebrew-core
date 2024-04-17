class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.2392.tar.gz"
  sha256 "f028c33691fa61878945be48bf76794ed638dae8b2b90e35b3930addde1aaa81"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "87b13771b2fe553a4322c2d3666b67aed9b0564b2f94a0813804d1a86cbfb0f2"
    sha256 cellar: :any,                 arm64_monterey: "78ad9467d81344264f8b6544dbba61c6081fbe1c6e492871d535cf5c82089ebf"
    sha256 cellar: :any,                 ventura:        "706e3ec817b6ab085d1abffd5e0396ffc66d865f28a6a049ad987255473b9e54"
    sha256 cellar: :any,                 monterey:       "0079843230abd573f87b9d956cc3ea4752f70996b2aaf27a965981198eba3505"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccaedff3009807df841330ea841f0bc1d0579e739a33e11f3a1d4d4f6df7e115"
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
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
