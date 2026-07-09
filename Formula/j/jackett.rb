class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2196.tar.gz"
  sha256 "efcc4261ebb2d515cf6baa0c71da129a7e2034206b66a5463405606d2ad82001"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "64c390d9d56cbad3bb0444e6bc5b11e80ad337f6b3254602f445dfbb19e75bab"
    sha256 cellar: :any, arm64_sequoia: "7f5da58ffff9ddf598b4757a8af43aeabe0b4828715920a1af28617f08d76a9a"
    sha256 cellar: :any, arm64_sonoma:  "d55ba1c766bc983ef28dbb00982bc155688e117d05687bfa88f84e935452c775"
    sha256 cellar: :any, sonoma:        "b4d96ce17be6a36bf7e38de6bd716d7bde52cab622baa10f50eea0c68c943f6a"
    sha256 cellar: :any, arm64_linux:   "5f64040fb8cc087e05650816278cd3b16e387c111b7515e197de64d5e3c1e816"
    sha256 cellar: :any, x86_64_linux:  "ed855b254af56f22b095bbe18f3979b3658ca1b2c48dbc6f42d86b0e91565d99"
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
