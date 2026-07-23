class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2257.tar.gz"
  sha256 "e7f6c49f1a8604fb6aa33dcce01dd1a980106e91ced73feb083baefcb0565ded"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3c7c2a7217248367458f51798ff89d0c84069713c8c3aee9271760cd136dc639"
    sha256 cellar: :any, arm64_sequoia: "c9a0b328e1ea659281918473d0a75e6904db6716ea65a3fa7fb2d00208ab5a8f"
    sha256 cellar: :any, arm64_sonoma:  "490619229209b39a333292653f98cdb7bdfb0e36d4b439d54a326cf65e11392e"
    sha256 cellar: :any, sonoma:        "aeee044c2ed1682e8a76c2ceb90d0e15313185d24a3504b60074ac3f73ed3d63"
    sha256 cellar: :any, arm64_linux:   "1b33bf7ec5b6f733fe0552d3dec0cc30d427cd2c753989d9389b60090cc58bd0"
    sha256 cellar: :any, x86_64_linux:  "753f443c269c45af073181aaef1ffa17b36df3082919f42f1a5884a7fa284983"
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
