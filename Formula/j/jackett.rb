class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1554.tar.gz"
  sha256 "1312e6c987c23d1c21b7c17756a230e8c626b6d8f030fa7ab468ba2de98c4032"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3fa132be1e4df33dc35185a9f2e4c6295ad95a0a80144d35e3ca79e5529f0e26"
    sha256 cellar: :any,                 arm64_sequoia: "b7b45caaeaa5bdf41d5a59a09e85045835607815f25a05086a75d67e6e81bac9"
    sha256 cellar: :any,                 arm64_sonoma:  "fdf2951f7a3d0c3308658c7655832fc347dc178fc8dd787f7bc1699d9a242be0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea4234296f002024a30380fac240aa9baadfef0734b54c4f1b2198b9d9043260"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e1899997d7a443790c08c32fe5b694440266537ea6dc8bfa7a0a93746ef908e"
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
