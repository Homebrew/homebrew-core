class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.37.tar.gz"
  sha256 "e0effa818e4ba39da7dd23e3d9951c4e132c5eccd570474cf82bebb734c8d377"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4a3436bb4662e5f7a0031479b5a12b99689386b017b28638f53e7844e448bf57"
    sha256 cellar: :any,                 arm64_sequoia: "c4cf69259617a673f890e4c650688bc193ed2c87b71e16d20919b25ab8346d02"
    sha256 cellar: :any,                 arm64_sonoma:  "46e6ce8347c5c7168179c5c02975925c61617e3f5cc69d52fa4ba08135dffa73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "834d2f222ea563cdf8005139b8651cb269c6847b462163771f4a3d9c5bb3f4f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "919c0c67f9416662a533d77a969d5e6e8fbb504c566db0de3ad7372504a788bb"
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
