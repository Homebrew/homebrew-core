class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.850.tar.gz"
  sha256 "f245e003f1b9fb48b1636811086624d57261d4eb970f7ed2955db319026f2502"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d985690f05b21547141d7ebad3e5de3152a4b942ba906e92f1c64674924e8023"
    sha256 cellar: :any,                 arm64_sequoia: "91a1d0d5bd08a8f88d9ccc1308b9c5af691efdf5a82711f4365f95e7006c45ea"
    sha256 cellar: :any,                 arm64_sonoma:  "86c197d837933bb750e3471e15213b841ebc1b32e4caa9fe209504a22cc5043f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff6bfad7946e0cc8743319223d01736f52291e2be6a71737ed32fee190ca0d61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41cc41d610e5af200ca233ea86e1ccc56709dc79100b8997daa893d33ca8932e"
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
