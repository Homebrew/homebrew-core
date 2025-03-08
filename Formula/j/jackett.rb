class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.1524.tar.gz"
  sha256 "cef5a1cd2f8203e1bb0f7485e556034c12422c6bcd0176e8924eda98d13dc5b2"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "73e9c7b20860fb34f039ca71db56f00d754b7317bf00a7266890e3e95d2359cd"
    sha256 cellar: :any,                 arm64_sonoma:  "4b226cbcf7d9470ed941def56a669a89d854482227f824458be60741eae929f5"
    sha256 cellar: :any,                 arm64_ventura: "2c08dbf33543dcac649b4c7765f1f2a286a89355cef6dba5367d6d205910d8d9"
    sha256 cellar: :any,                 ventura:       "317190cb15f8b9055e65e6755e1bad51f91d305bfab5e60777bc17761af998e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "750844fbf96aade632656c881e8eb172029acdcaf6afe47f9d29f4f092e59f2e"
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
