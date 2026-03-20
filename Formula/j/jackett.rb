class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1419.tar.gz"
  sha256 "9e3dfb98cd55abcc3546b3a1537d32893e63367161788fdef677cda85d31ba1e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4342301f081b428177600d155ca6ee8f1b755b73fcaccc93b01b1689dff76295"
    sha256 cellar: :any,                 arm64_sequoia: "326a73ddfb6d72fdd4a4e5e286973c36a34a84086ef0a01fb4c275abc254f35f"
    sha256 cellar: :any,                 arm64_sonoma:  "6b0ed2e5400ca6565728340018fd3fa56ea52fe816d5af0b5a388767d195f005"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df20a4a7b1831b2326929462f8e70b938e5f2e00d82fa014bd28e61258917006"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cb2379c008f26d736be1e106f0af74dfbdd5fbd31f2241f8dfc1ce27a0bf6b7"
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
