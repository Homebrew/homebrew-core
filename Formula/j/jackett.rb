class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.980.tar.gz"
  sha256 "8353f28b98f19e7391ef39eab6e9d1192c7366cd52657e85579a5f02859dcd21"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "61532a5a6a54a6c956b5a5aa91c12cd595a670dadab1cde7044dcbb9bbad5831"
    sha256 cellar: :any,                 arm64_sequoia: "cf2a5508c2c3195dcd1c908b63864b882b1c72bebea78c8998e10818269c058f"
    sha256 cellar: :any,                 arm64_sonoma:  "cff2a2f5b7146bb58a64d44faa54564978b596b469dab8886137601ce857022c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4576e55fa333ca4dfe309e2e394717aa2b74c1ffa9cde63ec69e8767bd3ff930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9d95355513c316d0c3375f03564337ef790221c8de19269a9603b44e2eceb6f"
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
