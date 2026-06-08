class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2031.tar.gz"
  sha256 "8ae544be4b4d6473187a5a75c1ec0954ebadc3b30bd2f189a991696f2caf4bf0"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c3dc9b4b693a5bb8dcb6c7d1ba2a612a97157cd1baa75a87926240aee0bceb0c"
    sha256 cellar: :any, arm64_sequoia: "cafecf8e06d469bd8ad4c011baddd687fd94171fd5ff6a37c183b08cfa371756"
    sha256 cellar: :any, arm64_sonoma:  "2c851f0b50cbb588d8f25e54569c77c8ce1ecaffbea47919c5b7fcb5e288e656"
    sha256 cellar: :any, sonoma:        "5362c71ae79d9ec5295d64b3ea64c617dd312f3b23df93953d8bba62fbbf4e39"
    sha256 cellar: :any, arm64_linux:   "d5a4cbd221f4da22d733ff5e2487c5a7fbf1af95b7cf774d29885c0a8492f04c"
    sha256 cellar: :any, x86_64_linux:  "d87b233b95c7b6bad888f0645e7ef5ddf11209c93868131e86e9ecaa29d283a6"
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
