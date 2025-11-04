class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.247.tar.gz"
  sha256 "901b25c134bc0a52a63c73d9dbc6d6b76756a34aeb4037eb97342900a761e6ff"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "288ddb1d31fe442322914c71ba9937f09986f4f7c3a55b5aa9bcbac1046c5dcb"
    sha256 cellar: :any,                 arm64_sequoia: "7f1f15d1d5274a8fc5ae26589a370f1e509f8774707787d787ab1842f3333614"
    sha256 cellar: :any,                 arm64_sonoma:  "48d6e55f50e542630692a1c1a9193237f2982a0f658c75cbcb5334c336ef8f91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "119d53716294010dc26bea203f5fe4520c26818461840894a13dfa67140c5cd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "822737f3ad4d6f8a86cbb07333ac743cc6556ba3ea8d32d1c3ee12e03afafd9e"
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
