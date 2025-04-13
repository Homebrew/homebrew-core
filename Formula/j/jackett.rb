class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.1767.tar.gz"
  sha256 "5f48d4003b4b8879730728d4680147469a9945162ac71a5fd3ccdad0cfe916eb"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a113e9c126619a12a7ce0e90b6ea3f32915eb127165917af985405e78ac4d6d1"
    sha256 cellar: :any,                 arm64_sonoma:  "7e8a1ad57708f4123782a6447dc02a065a64549bd79d519ec6925ed725cdbb16"
    sha256 cellar: :any,                 arm64_ventura: "38a9429041882fe9a8566b660ac9196a853e8dda62ce411c71e1f7f5ccb2534e"
    sha256 cellar: :any,                 ventura:       "eb106a4d83e770dec0e2c52f28eeea18bf5114e96b15c79a5f418241355f0912"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "202f50fd2807f3914e9f665970bf4c0ebfb61e51708f297aae49a018ec082e91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c256db2568866396523e73ca2f161c20029ec55e7a6553f5f1e2c0bc8af3ea6"
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
