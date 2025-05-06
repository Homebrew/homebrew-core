class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.1867.tar.gz"
  sha256 "719d576d370fca98c1c774ce07e135f44da0cc5d61c958223657c7862e4ecd1b"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c32771318ab4ea551316fb877752aa4c10898e4793088a8b2d40aa61c57a6879"
    sha256 cellar: :any,                 arm64_sonoma:  "c21e16ac2086f1b0448c1612fb5950023c42b0741f9d666567b16523d1e54fec"
    sha256 cellar: :any,                 arm64_ventura: "0b90d5fe21e4d564d2c22fa77ba736e664dfcbd48d4ebd6ee309135470a357b7"
    sha256 cellar: :any,                 ventura:       "d05753d382b7318c88721222c2c6cab136512fcdb359a13f16342207f0925d65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "594384b3135ceb37934f5c4129c1fa5a108b8575f349f79bd7c1edc5c55b83f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f12b4bea04beb60f404fa71c32bb7dfa139f7d4a49bec5be23d411c546fedad2"
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
