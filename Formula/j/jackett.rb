class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1779.tar.gz"
  sha256 "998a2fc094c5bc6cedc3f0f2277af016738d6a5b47827aa80661b0037d0d546c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "be7068a7ba5b6c1fb1a9583fbe4ce91ea3d3ea2ec2a26d3b408862e82e5d8f1d"
    sha256 cellar: :any,                 arm64_sequoia: "d4a1f6e3ec882db54f483fcf1b73ca95b998f7da8dd4ae762b262a09ba34c741"
    sha256 cellar: :any,                 arm64_sonoma:  "0931dcd485389ceda5295c08ccfe7df313602cc62f7b3ce3d6b37de9b3b1cdce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a13d30de60837ce654861bf3fbc9e037251577925f14ed4c019831e76423d1dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b48d27816f2400551ba220938963d253512b278a14ad1454efd40a65f989c1bb"
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
