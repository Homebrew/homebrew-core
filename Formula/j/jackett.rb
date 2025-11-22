class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.339.tar.gz"
  sha256 "cde4c3c33d6d4de704ae6d0ffc59de20896f6a6d303d0e4803d0d2b52aa25abf"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d52b76dd6752387218150b42b7ff35b016bc3e30a2119f1432f33981827958f8"
    sha256 cellar: :any,                 arm64_sequoia: "654ed0e932576abce33b10a9d59b611427cdb9833e17fba1bd51f3699df415a0"
    sha256 cellar: :any,                 arm64_sonoma:  "f5c0dda7bce05e1a2d06adeb707a5d9674915caa80d3f0d184379b4b7c6094dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a18d8742cf5d1f12327e6ba2a908decb5ebc6d7fc129ef2028f126c6bfce3a96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be058047d8a46a3bf6dd1426f476da6bac017142017825f43e8dc1de7e636779"
  end

  depends_on "dotnet"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet"]

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
