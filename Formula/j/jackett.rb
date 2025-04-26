class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.1826.tar.gz"
  sha256 "565036d6961986268ff3546b1cee12097040c1fe998d89c446901ae4798b2910"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "19259bd4820dcfc1870002fbdcfd8c8d84eba8c66c389a13c47cf6d7a82d1c60"
    sha256 cellar: :any,                 arm64_sonoma:  "aea9ea3948f559ee1da670ee5f7731d8f557c318e84caa33cf5de4f6621d7719"
    sha256 cellar: :any,                 arm64_ventura: "0f23c61c62f529dd88145dd38c5bb65e78f5e8d8e46c8c6ea315d751afafa43c"
    sha256 cellar: :any,                 ventura:       "c42dc1cdc1331f99a638ec38458ef18269eb4caf8bb8e891816e9e2aa2be039c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ab582445acf0051ab9ed98d5a2aa7ec416d8ddbc9ecd7d143f43908d42d7b94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "073ed6b21526604953194dc07260deae02b456765c53a7a94f6e713093eed60e"
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
