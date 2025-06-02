class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.1978.tar.gz"
  sha256 "a0cb2a3d4da4841ed974867e72936b6eb54e7d64965fd6e272db570e7ffb4379"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "92b3d953c5c978f6998b1e46d95f545c2de93feda85ddde1b2ed28844503d011"
    sha256 cellar: :any,                 arm64_sonoma:  "e9bff977e38deaa1f5773b5ede2f474280ca00945890cdae6d6163708207c0ae"
    sha256 cellar: :any,                 arm64_ventura: "2bc8f3b99e54d9e8ae0db67fb15f2b2ccaa8af398928f985d51dc4e2343ebe66"
    sha256 cellar: :any,                 ventura:       "120546b5573a5f971fc1fe6504615e46f90b90a941a9a734c009443adeae0367"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fadf43c0270c7acc02f2ab86b333ed90bb42717f26d22384983a509e387cd63d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a3d4b564e5ec9ce6e36fc6e69194e068a9fdd3fdf2285528b9e4d906106c5ac"
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
