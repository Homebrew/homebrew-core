class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.980.tar.gz"
  sha256 "8353f28b98f19e7391ef39eab6e9d1192c7366cd52657e85579a5f02859dcd21"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1410d5216bef2f65cedbdfa7a866d7baa79cc97719e9fb573222b917db817e33"
    sha256 cellar: :any,                 arm64_sequoia: "570516eb14c239cd658641767d003182a6d03b302bc728273ed8c89a0f50d064"
    sha256 cellar: :any,                 arm64_sonoma:  "c5cb3b9e1d73312f13ffb8bfac96bdb4c87c0f39a3ddedc8671ba8c41b829773"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f52ffe7f6c02b513509a300121b45faeaefd2e170a00192a111c5de0521bb580"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d61872e8941e963d8d7718596a56590a893483aa6dbc058746b30ef4d0047a2f"
  end

  depends_on "dotnet@9"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet@9"]

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

    pid = spawn bin/"jackett", "-d", testpath, "-p", port.to_s

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
