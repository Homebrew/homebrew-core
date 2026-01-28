class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.957.tar.gz"
  sha256 "3aeedcaecfad9f87666d73f1734d8372a4520cec732585ceb489dc177088dd6a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cc56f29d51f978e3c14a016d164ea955de04e46f51a2e8f83aae7e39177ec301"
    sha256 cellar: :any,                 arm64_sequoia: "bf6aaace9e068f812e5da81d1b0235b14de82f704551f601801671dccee3acf0"
    sha256 cellar: :any,                 arm64_sonoma:  "0c1e6029baca4b4e1642c2d168e5bf8a54093c370654d11d1a3938db09f85bba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97ca2d81710c590caa9fe5a5c2767521443633559bf41f1d1fb67408f90161fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18766bbdcb0d76087baf60f67515ac9a40bb3fe3e71b46611f3a30a7381ebdcb"
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
