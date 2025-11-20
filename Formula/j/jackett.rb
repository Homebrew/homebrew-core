class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.336.tar.gz"
  sha256 "e33556386fd02967b997179894011eb66286bd60abbd8e371f27393251ffd4d9"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6bc0aae46f987ed003867f862ee7ac2d12fa7517d29cb29793613660ef2a41e9"
    sha256 cellar: :any,                 arm64_sequoia: "9a40ecaab65c108708916077e2030afb5d3e5af4a8b65827dfa8ad7efde7b982"
    sha256 cellar: :any,                 arm64_sonoma:  "42ce3f13576a1863dfdea8d0b8d38478dfb3df89857414a89916349064f6ff35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60c1ed0c9960cf7fd3708fa88e91260166049cb87bffc267567d9b48fbed55ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e51e939b37232a18c55f7871329bc0bb75332ff6d6be65e0f8a3e8f088cbcfa"
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
