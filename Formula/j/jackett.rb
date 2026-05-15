class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1859.tar.gz"
  sha256 "8a43d7c7c3d5b25215bc7cbb4a33963665bb8e15926e6f8879d30b5bc3205114"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "157dd22ae00ef7b641dd9371870a6a2953f0bd27dec55d780879ca977366d0f3"
    sha256 cellar: :any,                 arm64_sequoia: "a0e384973b7c0ce183777ff30e1c4bd92b02d2336e1e6ed55200491939e367ee"
    sha256 cellar: :any,                 arm64_sonoma:  "5dd5f06eb1dcbe132e1b050854d71d5f1e365b4f48e141bfcc073a6a0214fbbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6748b968ba78da101b723080c58e14cbdae331d35f00f5c92810f42563b38294"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7dfe071c4a665d6b889a4d105e7c99b7374d7338356987fa9bffcadfc12062d"
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
