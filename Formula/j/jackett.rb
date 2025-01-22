class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.1292.tar.gz"
  sha256 "f973dc02e54bdc80e232e5527953b08f9ab7e3571e9a8befc80d37e74000cc41"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "da1ff22ded25d375e2a4506e3ec23bcadcfb00fd4286839826f8ba7c366cafa3"
    sha256 cellar: :any,                 arm64_sonoma:  "fa358dda6edcf2a28e16e7b22059bf7a0b99cf89676deba70d9df01536130b92"
    sha256 cellar: :any,                 arm64_ventura: "6aeafcbd94874cb85f9c0498d8ecd633981dff10037ca67531b35511b524838c"
    sha256 cellar: :any,                 ventura:       "7ef19702764d164556da86e07624ba7b555198a47bc39b71ee2a0cadb75ec816"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9be1190ecbac445f1c0edd17466f5c0a1f1cb0c43b2f32c0aeb109ae3c351ae"
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
