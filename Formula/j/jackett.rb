class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.1088.tar.gz"
  sha256 "087eb7923c54af1bb756beafc99568287fc400dc52e691d8d82d604f4671e779"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d92a850a7a31663265fa571caccf9b13efdc46b8772d1c6d1116e0198e4480f3"
    sha256 cellar: :any,                 arm64_sonoma:  "e21a31245e8a2cf453a231581815f0177b22a941899515febd2b67a3bb811d72"
    sha256 cellar: :any,                 arm64_ventura: "a1bb213b52840afa8cb429133d6ac7dc4f3d27ff451975b4ac0ed2f4af0be82f"
    sha256 cellar: :any,                 ventura:       "ed841d0ecdb30e69a63fa2ffafe0a2ce17fe4c4468940f7f89959ea89e18f954"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4048166690daa2d49cd2bbac80cfaa23c590910d0d4b1631835ba092d7b45a5c"
  end

  depends_on "dotnet@8"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet@8"]

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
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
      exec bin/"jackett", "-d", testpath, "-p", port.to_s
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
