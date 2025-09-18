class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.23.38.tar.gz"
  sha256 "a8b13da81d13e5ff925ad37d0ef7d36fdf6c31955ce14b017e6666bae717b502"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ca40c1e1a7a53736d38e257672442640eaf0d3f77d09fa8cbe8f89386ce05341"
    sha256 cellar: :any,                 arm64_sequoia: "85133133a124c4919fb291fcd7945d32ec5aa35db37660789423827e9cdc771b"
    sha256 cellar: :any,                 arm64_sonoma:  "3fe194b9c2d13bc2d7aefe45901d5cb7751c9054cc272b0cefcb71ca60f455a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5348c17a985aee940b7fef18b01a0111d77e953632ba2ad9d0838f3299c4db07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9be02edc84173053f16336dcfa9c629a6d4294a6b22823f43c38f9bfd52e93af"
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
