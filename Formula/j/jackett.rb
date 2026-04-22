class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1649.tar.gz"
  sha256 "0a769e322b90328213de070b84ecdc96f8d1ac53fba3f9a5359e40f3fed5f4c5"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3a246bd31a80c0022f58e50bc095120fbd28a403548ceeee5d491af181001611"
    sha256 cellar: :any,                 arm64_sequoia: "fbce0eecdc403afa8002ae14ed78e412d58c9c9930248ff01b3a695e00fadad2"
    sha256 cellar: :any,                 arm64_sonoma:  "5264a3437d5d9f40db3ee90722da310cf5d0ef00979f09be72d9c37df881c6ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b74f9ea139de674abf234ccdf631e136fd8d03b57869f7f61882db9734ca4504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89eed60d1e371c1f7337250b4045ad3e7265c0bc157837f70550401e620e4ae2"
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
