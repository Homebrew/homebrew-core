class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.23.32.tar.gz"
  sha256 "a2f15151d9bb198e092b9e1e38b53375c63ed2545355f728b592f7e63817581e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "70dbbb20b31359554b815970c389d5b4395e86075823a1d64e6c81ba2b8f756d"
    sha256 cellar: :any,                 arm64_sequoia: "ed93ba6ab1f53b875e92c899001ea492d365d4ac6006bffd1164e976d105b8c4"
    sha256 cellar: :any,                 arm64_sonoma:  "d045801d037aa0e7faf15464270f06b7e16568bb734e3889992d71582bbb6437"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "655fe7974e35700b13f97d159098fac093a64b53264bc34f36a1507179d5f6b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "011c7070d977fa8294e3f3db906f059e47ca68650180e33d22fb97f3de2dfd3e"
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
