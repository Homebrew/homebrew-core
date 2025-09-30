class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.7.tar.gz"
  sha256 "518151516f652dbb28246e201725072f844b8a0098ca260ae99b880bca979b3b"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8caa53a5dc6d2adce1fd1f8f11e48a44335899bcde7c295f31cd3ef3f07b4d6f"
    sha256 cellar: :any,                 arm64_sequoia: "8358452d2e707e045dfe86f483857fecb16a751120520d3ed25d547a0d05f416"
    sha256 cellar: :any,                 arm64_sonoma:  "502f5de142b65f27ab04d4fafcfff9071f23ebdb7928d13c48a970e2dd1e5b12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1834b809803c0c7224a8d5afe1a72dbf4666b957ac831e043ecc92fec79a2b82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51cc4468b7010abe36562021d4cc5ac14a4307c89a38bf6de9b44c840e32c69d"
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
