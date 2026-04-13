class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1577.tar.gz"
  sha256 "3b47131e3dce8f0e3033632bd6e82528af647ca77a8bc852adc0ae99d66eb507"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fd12a71c18d5552169c28cab63e54a23e5c16117903fedfc7379b0b7307cdee9"
    sha256 cellar: :any,                 arm64_sequoia: "6b4c65134a9ec8bc5f37c0f5e668686ba0d53a8a04cab434ccbc32302356648d"
    sha256 cellar: :any,                 arm64_sonoma:  "a86321d3915230d6a10b3f1bc0065171720795fcc42467c1dd1694ab53f97342"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61a39fd4aea53a2450d66796a867f805168fc1d5d443ba93c2138ce8458355af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fcbfa394188b8dbb21c6df3f58361275671113b02b31b949415f61361b7cb5a"
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
