class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.387.tar.gz"
  sha256 "cec1e984aa2a1146782de6a5a5b008b479dff853e69a4678ecdab6d9c12cf400"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d28b742b76fca2dffd2312da801dd2fa5bef39097c0ceed83ee6b86999e52c4c"
    sha256 cellar: :any,                 arm64_sequoia: "8520d7f7bb5a42b13f75baa90afd609ecd4e4bc5cb97fa03bfbecffd297b31b7"
    sha256 cellar: :any,                 arm64_sonoma:  "ac6572f45d5d64287d2d3510aeb4571f33cd4c52b72b5e5cf1fc49616c6d4679"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4fbbfb84623a08c48d8856828f3cc16aa8401e28ce89f43c85538c1ccca17fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aafb9979590744be438b4e4150c45de77fc6d25a803f667100b14fb6360d7f4b"
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
