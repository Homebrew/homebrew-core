class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1440.tar.gz"
  sha256 "61ed3f42452e317207f0c5fece8d5b47d14bd24880862dee0081acb028cd2fb5"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "38e2314d04c83ec6e02f323fdf034fc578fd3b5ea3866c7a0de50b5430444b18"
    sha256 cellar: :any,                 arm64_sequoia: "c43105e8ced6b35699b13be5af99a4649c0944508991de2cdcbde82f2af0d880"
    sha256 cellar: :any,                 arm64_sonoma:  "27362da600e60271647283bfd9f5dafb53feb9f8df19c240670ce9dcfb7c4890"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8855b90da5b324398765155a0e3550847ec2a62d4da61d78210a41a1fe5bf08f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64b09443b6786d77686774e9c5bd758a2daf4e7b75c280887e3e2c1ee6d20b7d"
  end

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
