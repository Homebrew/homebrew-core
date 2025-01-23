class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.1294.tar.gz"
  sha256 "397f4959bd5c7ba42c79a2a4cfaf85bbe3858c759bb870c481af703b63a4d903"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "622281b8667ff7c37b037f06182290374ad061f48b3d71797b6d0cbd07140bf7"
    sha256 cellar: :any,                 arm64_sonoma:  "9ee03f6c1fd65d26615761ea09c26109fda25bf1c9b6d737c6ab45f8f69ea68c"
    sha256 cellar: :any,                 arm64_ventura: "a4ebbd4a62028ff6bb3449cba8ebacad5a761f9451d0d16e32590b9e60d5e6c1"
    sha256 cellar: :any,                 ventura:       "da82001925f8e3137fa50be65411afcdff7e2e5be035040ead698c93b34c9218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "181e267a73009084279806718cd15e5f254f69c14f22354a439d16dbfb400c9b"
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
