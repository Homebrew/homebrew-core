class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1157.tar.gz"
  sha256 "106cac722a76e9d64153b5817b97eac7d7cfa2bd1fb99caa1b3e8c32d2f558a6"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "34e3820ab369b706ab5d55eca8cfcd9bf07a6e25b072be33ff21a4388ec56649"
    sha256 cellar: :any,                 arm64_sequoia: "b1f5d808850ba8155ecfe62ddd88769b3e862aae02371a7b7f0504784b28eb57"
    sha256 cellar: :any,                 arm64_sonoma:  "a3e27b2b896284d20c06f071fe7d4788a63a1061c3b5d2103d7ce773215843ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b9b7511228905072c0a6dadefa15d6e4c9c5d5b65ebf855a0b79aa11438dd74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57d43a039f3d26741b024a6c262cf22e0c0e49e7b9d0c24cd36224872ac71001"
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
