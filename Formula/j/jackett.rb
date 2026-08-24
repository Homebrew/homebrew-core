class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2457.tar.gz"
  sha256 "c8b7da0d5d707a3784f46b15ebf00e047b39a1b4b5119398af660e3c9acf5b65"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5d164f0ee64f22c9ef973fcf6f115afc873c9a326c3e55c1c36423e7c41fba85"
    sha256 cellar: :any, arm64_sequoia: "0aa7ea32f791ac86a4911f709585926e5ce8791069ef2798dc67b65c2dd4fc05"
    sha256 cellar: :any, arm64_sonoma:  "e28228a5b2ae34242f1e46667811baa2a1c12b300033497a170deeafecf51b14"
    sha256 cellar: :any, sonoma:        "f9ea0f2da9e1230bf5b4addfea930cd4da14a85b12c94423e998bcf181979d98"
    sha256 cellar: :any, arm64_linux:   "d51dca3b9d46b1380ec72109f75a7c039375a773e69e0f963f47d615e4703648"
    sha256 cellar: :any, x86_64_linux:  "355843e7d8a07166c24fb98dfa7f73578e3410f19dd1b753572f210a313db760"
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
