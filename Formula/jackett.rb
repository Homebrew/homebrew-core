class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3985.tar.gz"
  sha256 "38b7a7762733093f314297f210c42fc391af221d78563dde05ed7ff3469a925f"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "10277d0354b021c2bf2ed05a85e3229a492b867502ef5953433fc92b98fb3ad6"
    sha256 cellar: :any,                 arm64_monterey: "8634e61cbe4ae4be634fbd2ea5b2893a74a8e9dfc4a968510609823bf93a8b14"
    sha256 cellar: :any,                 arm64_big_sur:  "1b698bfafd444fcc41e0f47e25b3c7f08e738f35a2a2211d64b7966c5ab52c41"
    sha256 cellar: :any,                 ventura:        "675813798cb46a90575f2dca290c8005befa1dcdef6ac55882ccc00bed503df6"
    sha256 cellar: :any,                 monterey:       "573f5356390633df032cee05d49557f0ce47f4aebf74af51d263abb3f916d227"
    sha256 cellar: :any,                 big_sur:        "a599eca523959b4545fe8d7bdf81de533ec81dda547be6defaf6759c8362706e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6113d78c68a520fbc0102f33b741557b1c3d5d4f38cb4e087a1f748fdb578b0f"
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
