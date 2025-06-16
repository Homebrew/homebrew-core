class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2020.tar.gz"
  sha256 "1fc7c7d1d1fc83354f535196e3a829eb3d3d5c53ab94047525361c254d81e86c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ee0b328dd70b2cf7d69253c2fb4904dc71d95e74f0161ba62152b97ca123b3f8"
    sha256 cellar: :any,                 arm64_sonoma:  "e5f0a00361a9d5e8d7e714d33e20de4b2cfe692265c8357b6b00e55220ed9646"
    sha256 cellar: :any,                 arm64_ventura: "1b689daf635193d524fd39aac33dfeefa2d8916a0b3f6d364bfa98d9045a0444"
    sha256 cellar: :any,                 ventura:       "07a1b5260db4223d9bfd804c686ef8fc2ea1bb83d564d0ab68ac69a3da9ba69a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44d87cdadffa79e25a32096c655a0d3a5b71fb860991adf26e90d0565bfa42c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2af4b472acef0c3b07a00381dc0b6a16af4af8546162a8ccf08efc95c0dff17c"
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
