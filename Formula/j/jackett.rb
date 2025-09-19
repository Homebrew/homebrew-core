class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.23.43.tar.gz"
  sha256 "1aa48dbdc7454d3fbc7a58e92ab73aa56f76833d324ea31c0cf70b11e94b935e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "daa5cb77382cd9bbb20e9f133ef0f6924c0847f685260fc82132e33d8a7a800b"
    sha256 cellar: :any,                 arm64_sequoia: "bc6f2208bc87b514e3f174531e1370c01b63a9993b3db61fad151aae43141e53"
    sha256 cellar: :any,                 arm64_sonoma:  "f87ed07f4fccab4a70a2bffdc3ccacee0f93376d176db50d8ff916a8bba4d9c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d60ba336a9c995e7b136c3f2d364127e948f84b6b65c002d92a0437e27977a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3721467f680dbeb14e4a3863bb75d066632bd6a6948655842e14c5cb052c5b50"
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
