class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2125.tar.gz"
  sha256 "3e0b78b29566a3e043a409dd4d56ed92ac5070e4d23c7cfe4b0b8d77428bf5ab"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "99d6a3f0995467486fd7c827588af5c361f0535a0bb1400b2b4de84a3d049e99"
    sha256 cellar: :any, arm64_sequoia: "058aeee9ffe01f056f1341c0b4efa693d90d1037e481d740113443ebb0aa6332"
    sha256 cellar: :any, arm64_sonoma:  "afdf29f1c18d8b86ce847c15b2c4e8525ccc6c81aab90951ad3a90cd82ead4ad"
    sha256 cellar: :any, sonoma:        "925471b0f9ff2e7edbb87d2c3ca02392d111f7a4d8578fe006fc94a5aadbf3d9"
    sha256 cellar: :any, arm64_linux:   "8e317b7e2aa856aa5033dc0c6548cb09a26aaa2f6a48050efbb39c5c30bad033"
    sha256 cellar: :any, x86_64_linux:  "1059f513df50548eb1ca63b030df8073b8956c8229a1074583f8743752d5370d"
  end

  # Aligned to .NET dependency. Can remove if updated to latest .NET
  deprecate! date: "2026-11-10", because: "needs end-of-life .NET 9"
  disable! date: "2027-11-10", because: "needs end-of-life .NET 9"

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
