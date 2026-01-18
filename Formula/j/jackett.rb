class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.868.tar.gz"
  sha256 "2e3e2efdd214e5281939649332028799b30c6a4d219c7e5d10bd2b56a929e0f7"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "834d0da135df247596c528cec37100b8c4802c45145c90ac5a27e9ceaf5be1fe"
    sha256 cellar: :any,                 arm64_sequoia: "8608d1a7574395f84e28db05e1bd11fafdc4e67a7c4f5e30f176ca63a4aa0131"
    sha256 cellar: :any,                 arm64_sonoma:  "b76e6f5aabc9183a2894f79dbd9e82679b4e650fa741c3fc4983f389e9c5c7d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06b17f1bda2527d0289fff5fe8facffd44f335f95d05be3b80ede6e7a53fe181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1e9df2733b81ee966b86af7f940b3c9ad63c0e1355058aa66735e4d3a4fb99d"
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
