class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.1809.tar.gz"
  sha256 "dccd1e75dc4a40be231bd5c7b151f535a7bff2bf98649bd29a50187029395a98"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0a11c082b43f016837ab0a348a5964837e7b86617f7190c6f426cd5eea94e86c"
    sha256 cellar: :any,                 arm64_sonoma:  "8952b4ec6b8977ab1b02efa4365a461e1477ce015342dc562d16b7d8bf15e791"
    sha256 cellar: :any,                 arm64_ventura: "99757237906f80ac0b2e52139c30d5ffc5cb5f5e6162b8a784fc25ab46cb103a"
    sha256 cellar: :any,                 ventura:       "0328e9ed897effe968240e1d46b8144765ba4d2f47cc93712c50c8e12827dcfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d84136364d1c4ed264c19a5a55ae719aae384054451f4bb6844d7e1761afde3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bb635e042aaebed450bd492c8a4946149a36e6c7dc810a3e1993530439f0708"
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
